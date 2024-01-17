local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

orgs.newOrg('eclipse-csi') {
  settings+: {
    description: "",
    name: "Eclipse Common Security Infrastructure",
    web_commit_signoff_required: false,
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
    },
  },
  _repositories+:: [
    orgs.newRepo('otterdog') {
      description: "OtterDog is a tool to manage GitHub organizations at scale using a configuration as code approach. It is actively used by the Eclipse Foundation to manage its numerous projects hosted on GitHub.",
    },
    orgs.newRepo('security-handbook') {
      description: "This repository contains the source for the Eclipse Foundation Security Handbook.",
    },
    orgs.newRepo('gradually') {
      description: "This repository contains SDLC Security Levels for Eclipse Foundation Projects",
    },
  ],
}
