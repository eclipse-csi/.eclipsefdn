local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

local customRuleset(name) = 
  orgs.newRepoRuleset(name) {
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

local protectTags() = orgs.newRepoRuleset('tags-protection') {
  target: "tag",
  include_refs: [
    '~ALL'
  ],
  allows_creations: true,
  allows_deletions: false,	
  allows_updates: false,
  required_pull_request: null,
  required_status_checks: null,
};

orgs.newOrg('technology.csi', 'eclipse-csi') {
  settings+: {
    description: "The Eclipse CSI project",
    discussion_source_repository: "eclipse-csi/.github",
    has_discussions: true,
    name: "Eclipse Common Security Infrastructure",
    web_commit_signoff_required: false,
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
      topics+: [
        "github-actions",
        "python",
        "security",
        "supply-chain"
      ],
      webhooks: [
        orgs.newRepoWebhook('https://readthedocs.org/api/v2/webhook/octopin/285155/') {
          content_type: "json",
          events+: [
            "create",
            "delete",
            "pull_request",
            "push"
          ],
          secret: "pass:bots/technology.csi/readthedocs.org/octopin-webhook-secret",
        },
      ],
      environments: [
        orgs.newEnvironment('pypi'),
        orgs.newEnvironment('test-pypi'),
      ],      
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
      environments: [
        orgs.newEnvironment('pypi'),
        orgs.newEnvironment('test-pypi'),
      ],
      rulesets: [
        customRuleset("main") {
          required_status_checks+: {
            status_checks+: [
              "test (3.11)",
              "test (3.12)",
              "analyze"
            ],
          },
        },
        protectTags(),
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
      rulesets: [
        orgs.newRepoRuleset('main') {
          include_refs+: [
            "refs/heads/main",
          ],
          required_pull_request: null,
          required_status_checks: null,
        },
      ],
    },
    orgs.newRepo('dependency-track') {
      description: "Configuration files and guides for deployment and usage of Dependency Track at the Eclipse Foundation",
      homepage: "https://sbom.eclipse.org",
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
    orgs.newRepo('helm-charts') {
      description: "This repository contains the helm-charts source from Eclipse Foundation Security Infrastructure projects.",
      gh_pages_build_type: "workflow",
      homepage: "https://eclipse-csi.github.io/helm-charts/",
      environments: [
        orgs.newEnvironment('github-pages') {
          branch_policies+: [
            "gh-pages"
          ],
          deployment_branch_policy: "selected",
        },
      ],
    },
  ],
}
