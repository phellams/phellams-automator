# Build time for ci jobs global pipeline runtime

I would this to be a reusable buildtime, if we can export anything else at build time, we shileds.io perhaps enabe other ways to display the buildtime, simple and works. not bullshit. no over engineering.

Could we Create a parcial gitlab ci template and archor it in to jonbs so it remains the same

Shields.io does not offer a native upstream badge for GitLab CI pipeline runtime duration. To display a pipeline's execution time using Shields.io, you must generate a Custom Endpoint Badge or a Static Badge. This is accomplished by extracting the execution time during the pipeline runtime and serving it as a JSON artifact.Step 1: Add a badge generation job to .gitlab-ci.ymlAdd a final job to your GitLab CI configuration that calculates the pipeline runtime and writes a Shields.io JSON schema compliant file.yamlstages:
  - test
  - deploy
  - notify

generate_runtime_badge:
  stage: notify
  image: alpine:latest
  when: always  # Ensures it runs even if previous steps fail
  script:
    - apk add --no-cache curl jq
    # 1. Fetch the current pipeline duration via the GitLab API
    - |
      DURATION_SEC=$(curl --header "PRIVATE-TOKEN: $CI_API_TOKEN" \
        "$CI_API_V4_URL/projects/$CI_PROJECT_ID/pipelines/$CI_PIPELINE_ID" \
        | jq '.duration')
    # 2. Convert seconds to a human-readable format (MMm SSs)
    - MINUTES=$((DURATION_SEC / 60))
    - SECONDS=$((DURATION_SEC % 60))
    - RUNTIME_STR="${MINUTES}m_${SECONDS}s"
    # 3. Create the Shields.io JSON endpoint payload
    - |
      echo { \
        \"schemaVersion\": 1, \
        \"label\": \"runtime\", \
        \"message\": \"$RUNTIME_STR\", \
        \"color\": \"blue\" \
      } > runtime-badge.json
  artifacts:
    paths:
      - runtime-badge.json
    expire_in: 1 week
Use code with caution.Step 2: Determine your hosting methodTo feed the JSON artifact into Shields.io, the file must be publicly internet-accessible. You can expose your runtime-badge.json file in two ways:Option A: GitLab PagesDeploy the artifact to GitLab Pages by naming the job pages and placing the JSON file inside a folder named public/. Your URL will look like:https://<username>.gitlab.io/<project-name>/runtime-badge.jsonOption B: GitLab Artifacts APIKeep the file as a standard job artifact. You can access the raw file directly via GitLab's public API URL structure:https://gitlab.com<project-id>/jobs/artifacts/main/raw/runtime-badge.json?job=generate_runtime_badgeStep 3: Embed the Shields.io URLOnce your JSON file is accessible online, use the Shields.io Endpoint API to generate and display your dynamic badge inside your README.md file:markdown<!-- If using GitLab Pages -->
![Pipeline Runtime](https://shields.io<username>.gitlab.io/<project-name>/runtime-badge.json)

<!-- If using raw GitLab Artifacts URL -->
![Pipeline Runtime](https://shields.iogitlab.com/api/v4/projects/<project-id>/jobs/artifacts/main/raw/runtime-badge.json?job=generate_runtime_badge)
Use code with caution.If you are dealing with a private repository, Shields.io cannot access your internal endpoints. Let me know if your repository is private so we can review alternative local generation scripts or self-hosting workarounds.