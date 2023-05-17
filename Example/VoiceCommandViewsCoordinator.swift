//
//  VoiceCommandViewsCoordinator.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabbat on 11/05/2023.
//  Copyright © 2023 osApps. All rights reserved.
//

import Foundation
import UIKit
import OsTools

class VoiceCommandViewsCoordinator {
    
    // instances
    private var loadingSineStepper: SineStepper? = nil
    private var crowdSinesStepper: SineStepper? = nil
    
    func prepare(byDialog dialog: UIBottomVoiceCommandDialogView) {
        setLoadingSine(toSineView: dialog.loadingSineView)
        setCrowdSines(toCrowdSines: dialog.crowdSinesView)
    }
    
    func cleanAndRemove(_ dialog: UIBottomVoiceCommandDialogView) {
        crowdSinesStepper?.stopStepping()
        loadingSineStepper?.stopStepping()
        crowdSinesStepper = nil
        loadingSineStepper = nil
        dialog.crowdSinesView.clean()
        dialog.loadingSineView.stopAndClean()
    }
    
    private func setLoadingSine(toSineView sineView: UILoadingSineView) {
        let purpleMD = UIColor(named: "color purple DM purple med")!.withAlphaComponent(0.3)
        sineView.setSine(byFrequency: 1.37, amplitude: 19.78, andColor: purpleMD)
    }
    
    private func setCrowdSines(toCrowdSines crowdSinesView: UISineWaveView) {
        // create another 2 sines (one is sum)
        let purpleMD = UIColor(named: "color purple DM purple med")!
        if crowdSinesView.sineList.count == 2 {return}
        crowdSinesView.add(frequency: 0.75, amplitude: 26.45, color: purpleMD.withAlphaComponent(0.3))
        crowdSinesView.add(frequency: 1.37, amplitude: 19.78, color: purpleMD.withAlphaComponent(0.6))
    }
    
    private func buildLoadingStepper(bySineObj sineObj: SingleSineObj) -> SineStepper {
        let stepper = SineStepper(delay: 0.015)
        stepper.frequencyAmplitudeHandler = { freq, amp in
            sineObj.frequency = freq
            sineObj.amplitude = amp
        }
        return stepper
    }
    
    private func buildCrowdStepper(bySineObj sineObj: SingleSineObj) -> SineStepper {
        let stepper = SineStepper(delay: 0.015)
        
        // set steppers
        stepper.lastSetFrequency = sineObj.frequency!
        stepper.lastSetAmplitude = sineObj.amplitude!
        stepper.frequencyTargetFactor = 2.5
        stepper.amplitudeTargetFactor = 2.5
        stepper.frequencyStep = 0.02
        stepper.amplitudeStep = 0.5
        
        stepper.frequencyAmplitudeHandler = { freq, amp in
            sineObj.frequency = freq
            sineObj.amplitude = amp
        }
        return stepper
    }
}


// MARK: - Speech recognizer
extension VoiceCommandViewsCoordinator {
    func speechRecognizer(didRecieve partialText: String, andNewText newText: String, _ dialog: UIBottomVoiceCommandDialogView) {
        self.setPartialTextColor(label: dialog.voiceRecognizerLabel, normalText: partialText, appendedText: newText)
    }
    
    func speechRecognizer(didRecieve newVolume: CGFloat, _ dialog: UIBottomVoiceCommandDialogView) {
        loadingSineStepper?.move(toNewLocation: newVolume)
        crowdSinesStepper?.move(toNewLocation: newVolume)
    }
    
}
// MARK: - Phases
extension VoiceCommandViewsCoordinator {
    
    /** Adjust the views to show the loading phase */
    func setLoadingPhase(_ dialog: UIBottomVoiceCommandDialogView) {
        if let text = dialog.voiceRecognizerLabel.attributedText?.string {
            setPartialTextColor(label: dialog.voiceRecognizerLabel, normalText: text, appendedText: "")
            var fontSize = 17.0
            if Tools.getCurrentDevice() != .phone {
                fontSize = 19.0
            }
            dialog.voiceRecognizerLabel.font = FontsBank.satoshiBold(fontSize)
        }
        
        // start loading phase and hide all other sines
        dialog.loadingSineView.startLoadingPhase()
        dialog.crowdSinesView.fadeOut()
    }
    
    /** Adjust the views to show the voice recognizing phase */
    
    func setRecognizingPhase(withInitialTitle initialTitle: String, _ dialog: UIBottomVoiceCommandDialogView) {
        guard let loadingSineObj = dialog.loadingSineView.sine,
              let crowdFirstSine = dialog.crowdSinesView.sineList.first else {return}
        
        self.toggleCancelLabel(withNewText: "Cancel", dialog.cancelLabel)
        self.loadingSineStepper?.stopStepping()
        self.crowdSinesStepper?.stopStepping()
        
        self.loadingSineStepper = buildLoadingStepper(bySineObj: loadingSineObj)
        self.crowdSinesStepper = buildCrowdStepper(bySineObj: crowdFirstSine)
        
        self.loadingSineStepper!.startTimer()
        self.crowdSinesStepper!.startTimer()
        dialog.loadingSineView.start()
        dialog.crowdSinesView.run()
        self.setPartialTextColor(label: dialog.voiceRecognizerLabel, normalText: initialTitle, appendedText: "")
        dialog.voiceBtnContainer.fadeOut(withDuration: 0.25)
        dialog.crowdSinesView.fadeIn(withDuration: 0.5)
        dialog.loadingSineView.fadeIn(withDuration: 0.5)
        
    }
    
    /** Adjust the views to show the mic button phase */
    func setMicBtnPhase(withTitle title: String, _ dialog: UIBottomVoiceCommandDialogView) {
        dialog.crowdSinesView.alpha = 0.0
        self.toggleCancelLabel(withNewText: "Close", dialog.cancelLabel)
        dialog.loadingSineView.fadeOut {
            dialog.loadingSineView.stopAndClean()
            dialog.voiceBtnContainer.fadeIn()
        }
        
        self.setPartialTextColor(label: dialog.voiceRecognizerLabel, normalText: title, appendedText: "")
    }
    
    private func toggleCancelLabel(withNewText newText: String, _ label: UILabel) {
        label.fadeOut(withDuration: 0.2) {
            label.text = newText
            label.fadeIn(withDuration: 0.2)
        }
    }
    
//    /** Adjust the views to show the error phase. Currently forwarding the error to the mic phase! */
//    func setErrorPhase(withError error: Error, _ dialog: UIBottomVoiceCommandDialogView) {
//        setMicBtnPhase(withError: error.localizedDescription, dialog)
//    }
}

// MARK: - Utils
extension VoiceCommandViewsCoordinator {
    
    func setPartialTextColor(label: UILabel,
                             normalText: String,
                             appendedText: String) {
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "color purple DM purple med")!
        ]
        
        let appendedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: #colorLiteral(red: 0.6392156863, green: 0.6392156863, blue: 1, alpha: 1)
        ]
        
        let normalAttributedString = NSAttributedString(string: normalText, attributes: normalAttributes)
        let appendedAttributedString = NSAttributedString(string: appendedText, attributes: appendedAttributes)
        
        let combinedAttributedString = NSMutableAttributedString()
        combinedAttributedString.append(normalAttributedString)
        combinedAttributedString.append(appendedAttributedString)
        
        label.attributedText = combinedAttributedString
    }
}
