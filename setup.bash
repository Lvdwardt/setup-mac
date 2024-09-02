#!/bin/bash

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Make sure Homebrew is in the PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install packages from Brewfile
echo "Installing packages from Brewfile..."
BREWFILE_URL="https://raw.githubusercontent.com/Lvdwardt/setup-mac/main/Brewfile"
curl -fsSL "$BREWFILE_URL" | brew bundle --file=-

# Set macOS preferences
echo "Setting macOS preferences..."

# Set Dock to the left
defaults write com.apple.dock orientation left

# Set Dock hide and show speed
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0

# Disable natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Increase scroll speed (adjust the float value as needed)
defaults write NSGlobalDomain com.apple.trackpad.scrolling-speed -float 1.5

# Display time with seconds
defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  H:mm:ss"

# Set default browser to Google Chrome
# Note: This requires user interaction and can't be fully automated
open -a "Google Chrome" --args --make-default-browser

# Disable Siri
defaults write com.apple.Siri StatusMenuVisible -bool false
defaults write com.apple.Siri UserHasDeclinedEnable -bool true

# Enable accessibility for specific apps
# Note: This typically requires user interaction for security reasons
echo "Please manually enable accessibility for Amazon Q, Raycast, and Rectangle in System Preferences > Security & Privacy > Privacy > Accessibility"

# Restart affected apps
killall Dock
killall SystemUIServer

echo "Setup complete! Some changes may require a logout/restart to take effect."

# Disable "Show Spotlight search" keyboard shortcut
echo "Disabling 'Show Spotlight search' keyboard shortcut..."
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Disable "Show Finder search window" keyboard shortcut
echo "Disabling 'Show Finder search window' keyboard shortcut..."
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:65:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Restart cfprefsd to apply changes
killall cfprefsd

# Set up VS Code command line tool
echo "Setting up VS Code command line tool..."
if [ -d "/Applications/Visual Studio Code.app" ]; then
    # Check if the command already exists
    if ! command -v code &> /dev/null; then
        ln -s "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code
    fi
    
    # Install VS Code extensions
    echo "Installing VS Code extensions..."
    code --install-extension amazonwebservices.codewhisperer-for-command-line-companion
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension eamodio.gitlens
    code --install-extension editorconfig.editorconfig
    code --install-extension esbenp.prettier-vscode
    code --install-extension formulahendry.auto-close-tag
    code --install-extension formulahendry.auto-rename-tag
    code --install-extension gitHub.copilot
    code --install-extension github.copilot-chat
    code --install-extension mikestead.dotenv
    code --install-extension ms-vsliveshare.vsliveshare
    code --install-extension tal7aouy.icons
    code --install-extension wakatime.vscode-wakatime

    echo "VS Code extensions installed."
else
    echo "Visual Studio Code is not installed. Skipping extension installation."
fi

echo "Adding NVM configuration to .zshrc..."
cat << EOF >> ~/.zshrc

# NVM configuration
# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && $
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  #$
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew$

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] &&$

EOF

echo "NVM configuration added to .zshrc"

# Open specific applications and URLs
echo "Opening specified applications and URLs..."

# Open Chrome with specific URL
open -a "Google Chrome" https://wakatime.com/settings/api-key

# Open other applications
open -a "Amazon Q"
open -a "Discord"
open -a "Figma"
open -a "Raycast"
open -a "Rectangle"
open -a "Slack"
open -a "Visual Studio Code"

echo "Setup complete! Specified applications and URLs have been opened."
