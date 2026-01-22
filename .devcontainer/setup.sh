cat > .devcontainer/setup.sh << 'EOF'
#!/bin/bash
set -e

echo "🔧 Installing OpenJDK 17..."
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk wget unzip lib32z1 lib32stdc++6

echo "📦 Installing Gradle 8.5..."
wget -q https://services.gradle.org/distributions/gradle-8.5-bin.zip -O /tmp/gradle.zip
sudo mkdir -p /opt/gradle
sudo unzip -q /tmp/gradle.zip -d /opt/gradle
sudo ln -sf /opt/gradle/gradle-8.5/bin/gradle /usr/local/bin/gradle

echo "📱 Installing Android SDK..."
ANDROID_HOME="$HOME/android-sdk"
mkdir -p "$ANDROID_HOME/cmdline-tools/latest"
wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/sdk.zip
unzip -q /tmp/sdk.zip -d /tmp
mv /tmp/cmdline-tools/* "$ANDROID_HOME/cmdline-tools/latest/"
rm -rf /tmp/cmdline-tools /tmp/sdk.zip

echo 'export ANDROID_HOME=$HOME/android-sdk' >> "$HOME/.bashrc"
echo 'export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH' >> "$HOME/.bashrc"

export ANDROID_HOME
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

echo "✅ Accepting licenses..."
yes | sdkmanager --licenses >/dev/null 2>&1

echo "⬇️ Installing SDK packages..."
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

echo "✅ Setup complete! Java, Gradle, and Android SDK installed."
EOF

chmod +x .devcontainer/setup.sh
