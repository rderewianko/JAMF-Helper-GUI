//
//  manageControls.swift
//  JAMF Helper GUI
//
//  Created by Jordan Wisniewski on 11/18/15.
//
//  Copyright (C) 2015, JAMF Software, LLC All rights reserved.
//
//  THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
//  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
//  IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
//  DAMAGE.

import Cocoa

class manageControls: NSObject {
    
    // Enable the popup button if the dependency has text entered
    func popupButton(popup_button_control: NSPopUpButton, dependency: AnyObject) {
        
        if dependency.stringValue.characters.count > 0 {
            
            popup_button_control.enabled = true
            
        } else {
            
            popup_button_control.enabled = false
            popup_button_control.selectItemAtIndex(0)
            
        }
    }
    
    // Enable the segmented control if the dependency has text entered or a selection made
    func segmentedControl(segmented_control: NSSegmentedControl, dependency: AnyObject, dependency2: AnyObject?) {
        
        var dependency_value: String = ""
        var dependency2_value: String = ""
        
        if dependency is NSPopUpButton {
            
            dependency_value = String(dependency.selectedIndex)
            
        } else if dependency is NSTextField {
            
            dependency_value = dependency.stringValue
            
        }
        
        if (dependency2 != nil) {
            
            if dependency2 is NSPopUpButton {
                
                dependency2_value = String(dependency2!.selectedIndex)
                
            } else if dependency2 is NSTextField {
                
                dependency2_value = dependency2!.stringValue
                
            }
            
            if (dependency_value.characters.count > 0 || dependency2_value.characters.count > 0) {
                
                for var segment = 0; segment < segmented_control.segmentCount; ++segment {
                    
                    segmented_control.setEnabled(true, forSegment: segment)
                    
                }
                
            } else {
                
                for var segment = 0; segment < segmented_control.segmentCount; ++segment {
                    
                    segmented_control.setEnabled(false, forSegment: segment)
                    segmented_control.setSelected(false, forSegment: segment)
                    
                }
            }
            
        } else {
            
            if dependency_value.characters.count > 0 {
                
                for var segment = 0; segment < segmented_control.segmentCount; ++segment {
                    
                    segmented_control.setEnabled(true, forSegment: segment)
                    
                }
                
            } else {
                
                for var segment = 0; segment < segmented_control.segmentCount; ++segment {
                    
                    segmented_control.setEnabled(false, forSegment: segment)
                    segmented_control.setSelected(false, forSegment: segment)
                    
                }
            }
        }
    }
}
