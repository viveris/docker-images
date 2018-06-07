FROM node:8.11.2
RUN npm config set user 0 -g && \
    npm config set unsafe-perm true -g && \
    npm set loglevel=warn && \
    npm set progress=false && \
    npm install -g phantomjs-prebuilt@2.1.14 @angular/cli@1.4.4
