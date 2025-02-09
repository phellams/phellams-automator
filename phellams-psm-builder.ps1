# PSM_BUILDER_DOCKER_IMAGE
# ------------------------
import-module -name .\includes\modules\gitautoversion\Get-GitAutoVersion.psm1

$semver = (Get-GitAutoVersion).Version

# replace version in ascii art
(Get-Content -Path .\includes\acsiilogo-template.txt) | 
    ForEach-Object { $_ -replace "\[version\]", $semver } | 
        Set-Content -Path .\includes\acsiilogo-template.txt

# Build the Docker image
docker build -t phellams-psm-builder:latest -f phellams-psm-builder.dockerfile .
# test the image
docker run phellams-psm-builder:latest pwsh -c get-module -list
# push to proget - Currently Accessing proget via password passed in via stdin fails
# normal login works however: docker login -u user
# --------------
# $ENV:PROGET_API_KEY | docker login -u admin --password-stdin $ENV:PROGET_HOST
# # tag with latest
# docker tag phellams-psm-builder $ENV:PROGET_HOST/docker/phellams-psm-builder:latest
# # tag with gitautoversion
# docker tag phellams-psm-builder $ENV:PROGET_HOST/docker/phellams-psm-builder:$semver
# # push latest
# docker push $ENV:PROGET_HOST/docker/phellams-psm-builder:latest
# # push gitautoversion semver
# docker push $ENV:PROGET_HOST/docker/phellams-psm-builder:$semver

# docker logout
# --------------

# Push to Docker Hub-Commit
# -----------------
# $ENV:DOCKERHUB_API_KEY | docker login -u $ENV:DOCKERHUB_USER --password-stdin
# docker tag phellams-psm-builder $ENV:DOCKERHUB_USER/phellams-psm-builder:latest
# docker push $ENV:DOCKERHUB_USER/phellams-psm-builder:latest
# docker logout  
$ENV:DOCKERHUB_API_KEY | docker login -u sgkens --password-stdin
docker tag phellams-psm-builder sgkens/phellams-psm-builder:latest
docker push sgkens/phellams-psm-builder:latest
docker logout 