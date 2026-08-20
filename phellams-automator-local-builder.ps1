param (
    [Parameter(Mandatory = $true)]
    [ValidateSet("Base", "choco", "about", 'clean', 'deep-clean')]
    [string]$buildMode
)

# PSM_BUILDER_DOCKER_IMAGE
# ------------------------
import-module -name .\includes\modules\gitautoversion\Get-GitAutoVersion.psm1

$semver = (Get-GitAutoVersion).Version


# replace version in ascii art
(Get-Content -Path .\includes\acsiilogo-template.txt) |
    ForEach-Object { $_ -replace "\[version\]", $semver } |
        Set-Content -Path .\includes\acsiilogo-template.txt


Switch ($buildMode) {
    'choco' {
        # Build the Docker image
        docker buildx build -t phellams-automator-choco:localbuild -f phellams-automator-choco.dockerfile .
        # test the image output with a simple command
        docker run phellams-automator-choco:localbuild pwsh -c get-module -list
    }
    'Base' {
        # Build the Docker image
        docker buildx build -t phellams-automator:localbuild -f phellams-automator.dockerfile .
        # push to proget - Currently Accessing proget via password passed in via stdin fails
        # normal login works however: docker login -u user
        # --------------
        # $ENV:PROGET_API_KEY | docker login -u admin --password-stdin $ENV:PROGET_HOST
        # # tag with latestabout
        # docker tag phellams-psm-buphellams-automator-local-builderilder $ENV:PROGET_HOST/docker/phellams-psm-builder:latest
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
        # $ENV:DOCKERHUB_API_KEY | docker login -u sgkens --password-stdin
        # docker tag phellams-psm-builder sgkens/phellams-psm-builder:latest
        # docker push sgkens/phellams-psm-builder:latest
        # docker logout
    }
    'about' {
        # Test image output with get-about
        docker run phellams-automator:localbuild pwsh -c get-about
        # test the image output with a simple command
        docker run phellams-automator:localbuild pwsh -c get-module -list
    }
    'clean' {
        # remove all local images matching the tag 'phellams-automator:localbuild'
        docker rmi -f $(docker images --filter "reference=sgkens/phellams-automator:*" -q)
    }
    'deep-clean' {
        # remove all local images matching the tag 'phellams-automator:localbuild'
        docker rmi -f $(docker images --filter "reference=sgkens/phellams-automator:*" -q)
        # remove all dangling images (those without a tag)
        docker image prune -f  # removes ALL dangling images, not scoped to phellams-automator
    }

    default {
        [console]::write("Please choose a valid build mode: choco or Base`n")
    }
}
