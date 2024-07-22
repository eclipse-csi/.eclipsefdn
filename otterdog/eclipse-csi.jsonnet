local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

orgs.newOrg('eclipse-csi') {
  settings+: {
    description: "The Eclipse CSI project",
    discussion_source_repository: "eclipse-csi/.github",
    has_discussions: true,
    name: "Eclipse Common Security Infrastructure",
    web_commit_signoff_required: false,
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
    },
  },
  _repositories+:: [
    orgs.newRepo('.github') {
      has_discussions: true,
    },
    orgs.newRepo('gradually') {
      description: "This repository contains SDLC Security Levels for Eclipse Foundation Projects",
    },
    orgs.newRepo('octopin') {
      dependabot_security_updates_enabled: true,
      description: "Analyses and pins GitHub actions in your workflows.",
      has_projects: false,
    },
    orgs.newRepo('otterdog') {
      dependabot_security_updates_enabled: true,
      description: "OtterDog is a tool to manage GitHub organizations at scale using a configuration as code approach. It is actively used by the Eclipse Foundation to manage its numerous projects hosted on GitHub.",
      has_discussions: true,
      has_projects: false,
      homepage: "https://otterdog.readthedocs.org",
      topics+: [
        "asyncio",
        "configuration-as-code",
        "github-config",
        "python",
        "security",
        "supply-chain"
      ],
      webhooks: [
        orgs.newRepoWebhook('https://readthedocs.org/api/v2/webhook/otterdog/260699/') {
          content_type: "json",
          events+: [
            "create",
            "delete",
            "pull_request",
            "push"
          ],
          secret: "pass:bots/technology.csi/readthedocs.org/otterdog-webhook-secret",
        },
      ],
      secrets: [
        orgs.newRepoSecret('IQ_TOKEN') {
          value: "pass:bots/technology.csi/sonatype-lifecycle/iq-token",
        },
      ],
      environments: [
        orgs.newEnvironment('pypi'),
      ],
    },
    orgs.newRepo('security-handbook') {
      description: "This repository contains the source for the Eclipse Foundation Security Handbook.",
      gh_pages_build_type: "workflow",
      homepage: "https://eclipse-csi.github.io/security-handbook/",
      environments: [
        orgs.newEnvironment('github-pages') {
          branch_policies+: [
            "main"
          ],
          deployment_branch_policy: "selected",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 0,
        },
      ],
    },
    orgs.newRepo('sonatype-lifecycle') {
      description: "Configuration files and guides for deployment and usage of Sonatype Lifecycle at the Eclipse Foundation",
    },
  ],
}
