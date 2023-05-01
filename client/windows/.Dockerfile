ARG WINDOWS_IMAGE="mcr.microsoft.com/windows"
ARG WINDOWS_DIGEST="latest"
ARG GITHUB_USERNAME
ARG GITHUB_TOKEN
ARG CLIENT_REPO

FROM $WINDOWS_IMAGE:$WINDOWS_DIGEST

RUN powershell -Command "Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.32.0.windows.1/Git-2.32.0-64-bit.exe -OutFile git.exe ; Start-Process .\git.exe -ArgumentList '/VERYSILENT', '/NORESTART', '/NOCANCEL', '/SP-', '/CLOSEAPPLICATIONS', '/RESTARTAPPLICATIONS', '/COMPONENTS=\"icons,ext\\", '/TASKS=desktopicon,quicklaunchicon,registerassoc,registermenus,addconsoleshortcuts,associatehttp,associatehttps,associateftp,associatessh', -NoNewWindow -Wait" || \
    echo "Unsupported package manager"

