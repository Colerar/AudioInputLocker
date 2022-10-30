#!/usr/bin/env zsh

swift build -c release --arch arm64 --arch x86_64 && \
    mv .build/apple/Products/Release/AudioInputLocker .build/ail && \
    strip .build/ail

lipo -info .build/ail
