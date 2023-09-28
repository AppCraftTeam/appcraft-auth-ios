#!/bin/sh

$(xcrun --find docc) process-archive transform-for-static-hosting ACAuth.doccarchive --hosting-base-path appcraft-auth-ios --output-path ./docs