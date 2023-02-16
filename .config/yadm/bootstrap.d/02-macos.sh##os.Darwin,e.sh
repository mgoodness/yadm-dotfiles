# shellcheck shell=bash
#
# Update macOS preferences
#
# References
# - Inspiration: https://mths.be/macos

### General ###
debug "General"
defaults write NSGlobalDomain AppleInterfaceStyle -string Dark      # Dark mode
defaults write NSGlobalDomain AppleWindowTabbingMode -string always # Prefer tabs
# Touch ID for sudo
if ! grep -q pam_tid.so /etc/pam.d/sudo; then
    sudo sed -i .bak -e "2s/^/auth       sufficient     pam_tid.so\n/" /etc/pam.d/sudo
fi

### Dock ###
debug "Dock"
defaults write com.apple.dock orientation -string bottom # Place at bottom
defaults write com.apple.dock show-recents -bool false   # Hide recent apps
defaults write com.apple.dock magnification -int 1       # Enable magnification
defaults write com.apple.dock largesize -int 80
dockutil --no-restart --remove all
dockutil --no-restart --add /System/Applications/Calendar.app
dockutil --no-restart --add /System/Applications/Mail.app
dockutil --no-restart --add /System/Applications/Messages.app
dockutil --no-restart --add /Applications/Slack.app
dockutil --no-restart --add /System/Applications/Music.app
dockutil --no-restart --add /System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app # https://github.com/kcrawford/dockutil/issues/144
dockutil --no-restart --add /Applications/Kitty.app
dockutil --no-restart --add /System/Applications/Notes.app
dockutil --no-restart --add /System/Applications/Reminders.app
dockutil --no-restart --add /System/Applications/System\ Settings.app
dockutil --no-restart --add ~/Documents --sort name --display folder --view list
dockutil --no-restart --add ~/Downloads --sort dateadded --display folder --view fan

### Finder ###
debug "Finder"
chflags nohidden ~/Library
defaults write com.apple.finder NewWindowTarget -string "PfHm"             # Set default path to $HOME
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"        # Use column view
defaults write com.apple.finder _FXSortFoldersFirst -int 1                 # Sort folders first
defaults write com.apple.finder QLEnableTextSelection -bool true           # Enable copy from quicklook
defaults write com.apple.finder WarnOnEmptyTrash -bool false               # Don't warn when emptying trash
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false # Don't warn when changing an extension
for ext in public.{data,json,plain-text,python-script,shell-script,source-code,text,unix-executable} .go .java .{j,t}s{,x} .json .md .py .rb .txt .toml .y{,a}ml; do
    duti -s com.microsoft.VSCode "$ext" all # Set VSCode as default app for code
done

### Mission Control ###
debug "Mission Control"
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock wvous-tl-corner -int 10 # Top left: Display sleep
defaults write com.apple.dock wvous-tr-corner -int 12 # Top right: Notification center

### Sharing ###
debug "Sharing"
if [ "$(scutil --get ComputerName)" != "Goodness's MacBook Pro" ]; then
    scutil --set ComputerName "Goodness's MacBook Pro"
    scutil --set LocalHostName "Goodness-MacBook-Pro"
fi

### Siri ###
debug "Siri"
defaults write com.apple.assistant.support "Assistant Enabled" -bool false

### Software Update ###
debug "Software Updates"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1 # Check for updates daily

### Trackpad ###
debug "Trackpad"
defaults write -g com.apple.trackpad.scaling 3 # Max trackpad speed

### Wallpaper ###
debug "Wallpaper"
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/System/Library/Desktop Pictures/Ventura Graphic.heic"'

# Restart affected apps
debug "Restarting apps"
for app in Dock Finder; do
    killall "$app"
done