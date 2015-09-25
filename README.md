# APK Tools --
> *"A complete fresh tool developed from scratch; inspired by existing tools available out there."*

## Requirements:

- Java JDK/JRE
- Android SDK
- BRAIN! ^_^


## Features:

- Faster and easier APK handling *(GUI Version) -- supports drag and drop file; access files anywhere*
- All-in-one *(ADB Push/Pull, Extract, Optimize, Zip, Sign, Zipalign, Install, Decompile, Compile...)*
- Based on latest available tools
- Great user interaction; less prone to errors *(More information and warning during operation)*
- Works everytime and anywhere *(No problem with paths and filename containing spaces or weird characters)*
- Log activities with time stamp and use date as log filename
- Install and use of framework with custom tags
- Generate and sign APKs with own private key *(Android market supported)*
- Switch between apktool versions *(2.0.0b9 & 1.5.2)*
- Many more . . . Check for yourself! ;D


## To Do:
- ~~Log activities with time and date headers~~ - ***Done***
- ~~Install framework with custom tags~~ - ***Done***
- ~~Generate own private key with android market support~~ - ***Done***
- ~~Sign APKs with the generated private key~~ - ***Done***
- ~~GUI version with drop file support~~ - ***Done***
- ~~Switch between APKTOOL versions~~ - ***Done***


## Instructions:
1. Extract "APK Tool v#.##.zip"
2. Execute "APK Tools.exe"

- Necessary files and folders are installed automatically every launch if not found.
- Place APKs to be modded inside "APK Files" folder.
- All extracted or decompiled APKs are found in "Projects" folder.
- Generated private keys are located in "OUTPUT" folder.
- Zipped, signed, zipaligned and/or compiled projects are found in "OUTPUT" folder.

| Project | Output |
| :------------: | :---------------: |
| Zipped/Compiled with Original Signature | system-%Project% |
| Zipped/Compiled with No Signature | unsigned-%Project% |
| Signed with Generated Private Keys | gpsigned-%Project% |
| Signed with Android Market | amsigned-%Project% |
| Signed with Test Keys | signed-%Project% |


## Credits:
- Google for Overall HELP and Android Tools
- Brut.all / iBotPeaches for apktool
- jesusfreke for smali/backsmali
- deanlee3 for roptipng
- Igor Pavlov for 7zip
- Yorzua for signapk
