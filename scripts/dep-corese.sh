#!/bin/bash

cd ..
git clone https://github.com/Wimmics/corese.git
cd corese
mvn clean install -Dmaven.test.skip=true
