local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

local customRuleset(name) = 
  orgs.newRepoRuleset(name) {
    bypass_actors+: [
      "@eclipse-csi/technology-csi-project-leads"
    ],
    include_refs+: [
      std.format("refs/heads/%s", name),
    ],
    required_pull_request+: {
      required_approving_review_count: 1,
      requires_last_push_approval: true,
      requires_review_thread_resolution: true,
      dismisses_stale_reviews: true,
    },
    requires_linear_history: true,
  };

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
  secrets+: [
    orgs.newOrgSecret('DEPENDENCY_TRACK_API_KEY') {
      selected_repositories+: [
        "otterdog"
      ],
      value: "********",
      visibility: "selected",
    },
  ],
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
      code_scanning_default_setup_enabled: true,
      code_scanning_default_languages: ["python"],
      dependabot_security_updates_enabled: true,
      description: "OtterDog is a tool to manage GitHub organizations at scale using a configuration as code approach. It is actively used by the Eclipse Foundation to manage its numerous projects hosted on GitHub.",
      has_discussions: true,
      has_projects: false,
      homepage: "https://otterdog.readthedocs.org",
      private_vulnerability_reporting_enabled: true,
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
      rulesets: [
        customRuleset("main") {
          required_status_checks+: [
            "test (3.10)",
            "test (3.11)",
            "test (3.12)",
            "analyze"
          ],
        },
      ],
    },
    orgs.newRepo('security-handbook') {
      description: "This repository contains the source for the Eclipse Foundation Security Handbook.",
      gh_pages_build_type: "workflow",
      homepage: "https://eclipse-csi.github.io/security-handbook/",
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 0,
        },
      ],
      environments: [
        orgs.newEnvironment('github-pages') {
          branch_policies+: [
            "main"
          ],
          deployment_branch_policy: "selected",
        },
      ],
    },
    orgs.newRepo('sonatype-lifecycle') {
      description: "Configuration files and guides for deployment and usage of Sonatype Lifecycle at the Eclipse Foundation",
    },
    orgs.newRepo('workflows') {
      dependabot_security_updates_enabled: true,
      description: "Collection of reusable workflows.",
      has_projects: false,
      has_wiki: false,
    },
  ],
}
