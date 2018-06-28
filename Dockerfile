# use stable alpine 3.8
FROM alpine:3.8

# install ansible, composer, git, hugo, openssh-client and tar
RUN apk add --no-cache ansible composer git hugo openssh-client tar

# install ansistrano
RUN ansible-galaxy install carlosbuenosvinos.ansistrano-deploy,2.9.1
