#!/bin/bash

export ANTLR_LIB=../antlrphp-git/lib
# export ANTLR_LIB=/Users/roll/Documents/projects/antlrphpruntime-read-only-new/lib
export CLASSPATH=$CLASSPATH:$ANTLR_LIB/antlr-3.1.3-php.jar:$ANTLR_LIB/antlr-2.7.7.jar:$ANTLR_LIB/antlr-runtime-3.1.3.jar:$ANTLR_LIB/gunit.jar:$ANTLR_LIB/stringtemplate-3.2.jar 

java -Xms32m -Xmx512m org.antlr.Tool MOS.g
