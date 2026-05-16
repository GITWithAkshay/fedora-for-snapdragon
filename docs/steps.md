<!-- markdownlint-disable MD013 -->
# Step Log

## 2026-05-15T21:27:00+05:30

- Step name: Documentation scaffold
- Action: Created `docs/steps.md`, `docs/problems/`, `docs/solutions/`,
  and `CHANGELOG.md` for immediate logging and version tracking.
- Result: Documentation structure initialized successfully.

## 2026-05-15T21:29:00+05:30

- Step name: Cross-platform git hygiene
- Action: Added `.gitattributes` to preserve LF line endings for
  Linux-facing files and `.gitignore` for local development artifacts.
- Result: Repository line ending behavior and local ignore rules are now defined.

## 2026-05-15T21:32:00+05:30

- Step name: Logged missing pre-commit problem
- Action: Documented the missing `pre-commit` executable and its
  reproduction details in
  `docs/problems/2026-05-15-pre-commit-missing.md`.
- Result: Error captured before remediation.

## 2026-05-15T21:36:00+05:30

- Step name: Environment scaffolding
- Action: Added Windows and Fedora WSL bootstrap scripts,
  `pre-commit` configuration, `package.json`, `requirements-dev.txt`,
  and validation workflow documentation.
- Result: The repository can now bootstrap and validate a repeatable
  development environment.

## 2026-05-15T21:39:00+05:30

- Step name: Logged markdownlint failures
- Action: Recorded bootstrap-time `markdownlint` errors in
  `docs/problems/2026-05-15-markdownlint-failures.md` before attempting
  a fix.
- Result: Validation failure is now documented for remediation.

## 2026-05-15T21:33:15+05:30

- Step name: Validation hardening
- Action: Reformatted Markdown files for lint compliance, upgraded
  `markdownlint-cli` in `package.json`, and added a checked-command
  wrapper plus a reusable step logger.
- Result: Documentation and bootstrap scripts are stricter and easier to maintain.

## 2026-05-15T21:44:25+05:30

- Step name: Logged WSL shellcheck issue
- Action: Captured the SC1091 shellcheck finding for
  `scripts/setup-wsl-fedora.sh` in
  `docs/problems/2026-05-15-shellcheck-sc1091-setup-wsl.md` before
  changing the script.
- Result: The Fedora WSL validation failure is documented with
  reproduction details.

## 2026-05-15T21:45:39+05:30

- Step name: Logged step log newline issue
- Action: Captured the end-of-file-fixer failure caused by `docs/steps.md`
  lacking a final newline in
  `docs/problems/2026-05-15-step-log-missing-final-newline.md`.
- Result: The cross-platform newline issue is documented before changing
  the logger again.

## 2026-05-15T21:55:25+05:30

- Step name: Environment validated
- Action: Verified npm Markdown lint, Windows bootstrap, Fedora WSL
  validation, and Fedora WSL bootstrap all complete successfully after
  tightening newline handling and Markdown lint scope.
- Result: The repository now boots a repeatable development environment
  on both Windows and Fedora WSL.

## 2026-05-15T21:55:29+05:30

- Step name: Release preparation
- Action: Added solution records for resolved bootstrap issues and bumped
  the repository version metadata from v0.1.0 to v0.1.1 in `CHANGELOG.md`
  and `package.json`.
- Result: The current development environment state is documented and
  ready to commit.

## 2026-05-15T21:58:08+05:30

- Step name: Hook path repaired
- Action: Documented the Git hook PATH issue, reinstalled `pre-commit`
  from the Windows virtual environment, and confirmed the generated hook
  now points to `.venv-windows\Scripts\python.exe`.
- Result: Local Windows commits can run the repository `pre-commit` hook
  without manual virtualenv activation.

## 2026-05-15T22:32:58+05:30

- Step name: Build prerequisites check
- Action: Confirmed the repository is clean on master, the workspace already contains the validated dual-environment tooling, and Fedora WSL is available on aarch64 with sufficient free space for a kernel source and build tree.
- Result: The build can proceed in-place under Fedora WSL without additional environment bootstrap work.

## 2026-05-15T22:58:32+05:30

- Step name: Kernel source bootstrap
- Action: Created sources/ and build-output/, cloned the mainline Linux kernel into sources/linux-mainline from kernel.org, and verified the checkout is on master at commit 70eda6866.
- Result: A current upstream kernel source tree is available locally for the Galaxy Book4 Edge build flow.

## 2026-05-15T22:59:02+05:30

- Step name: Logged missing upstream DTS
- Action: Documented that the freshly cloned mainline Linux tree at sources/linux-mainline commit 70eda6866 does not contain a Galaxy Book4 Edge DTS or Makefile reference.
- Result: The first build blocker is recorded before switching to a different source strategy.

## 2026-05-15T23:00:52+05:30

- Step name: Logged linux source lock issue
- Action: Recorded the stale .git/index.lock error from sources/linux-mainline before modifying the kernel source repository state.
- Result: The patch-application blocker is documented for safe remediation.

## 2026-05-15T23:04:12+05:30

- Step name: Logged inconsistent kernel clone
- Action: Recorded the linux-mainline checkout failure where git treated standard kernel files as untracked and refused branch creation after the interrupted source bootstrap.
- Result: The second kernel-source blocker is documented before choosing a recovery strategy.

## 2026-05-15T23:15:02+05:30

- Step name: WSL ext4 kernel clone
- Action: Created a clean mainline Linux clone in Fedora WSL at ~/book4edge-build/linux-mainline on the ext4 filesystem and verified it is clean on master at commit 70eda6866.
- Result: A stable source tree now exists outside /mnt/c for patching and kernel builds.

## 2026-05-15T23:15:27+05:30

- Step name: Logged WSL git identity issue
- Action: Recorded the Fedora WSL git am failure caused by missing committer name and email in the clean ext4 kernel source tree.
- Result: The patch-application dependency is documented before setting repository-local git identity.

## 2026-05-15T23:15:50+05:30

- Step name: Logged missing mailbox path
- Action: Recorded the git am failure caused by relying on /tmp/galaxy-book4-edge-v5.mbox across shell sessions instead of a persisted patch file path.
- Result: The patch-input issue is documented before moving the mailbox to a durable location.

## 2026-05-15T23:16:21+05:30

- Step name: Logged empty cover-letter stop
- Action: Recorded the git am stop on the 0/6 Galaxy Book4 Edge thread cover letter in patches/galaxy-book4-edge-v5.mbox before advancing the patch series.
- Result: The mailbox replay behavior is documented and ready for a controlled skip of the empty cover letter.

## 2026-05-15T23:16:51+05:30

- Step name: Logged patch bitrot
- Action: Recorded the first non-empty Galaxy Book4 Edge patch failing against current mainline in the qcom inline crypto engine binding file.
- Result: The upstream drift is documented before choosing a patch-replay strategy.

## 2026-05-15T23:18:33+05:30

- Step name: Logged helper dependency gap
- Action: Recorded the temporary WSL patch-inspection helper failing because it assumed the third-party Python requests module was installed.
- Result: The helper-script dependency issue is documented before retrying with the Python standard library.

## 2026-05-15T23:19:57+05:30

- Step name: Applied rebased Book4 Edge DTS patch
- Action: Extracted the rebased v6 Galaxy Book4 Edge DTS diff from the public patch page into patches/galaxy-book4-edge-v6.patch, applied it on the clean WSL ext4 kernel clone with git apply --index, and committed it locally in the build tree.
- Result: The kernel source now contains x1-samsung-galaxy-book4-edge.dtsi plus the 14-inch and 16-inch Samsung Galaxy Book4 Edge DTS files.

## 2026-05-15T23:20:31+05:30

- Step name: Logged inline build path failure
- Action: Recorded the failed inline WSL kernel build bootstrap where the output directory variable expanded to an empty path before the first make step.
- Result: The compile bootstrap issue is documented before moving the build flow into a dedicated script.

## 2026-05-15T23:20:53+05:30

- Step name: Added WSL build entrypoint
- Action: Created scripts/build-book4edge-wsl.sh to drive the Book4 Edge kernel build from the stable WSL ext4 source tree, merge the Snapdragon config fragment, build Image.gz and the Samsung 14-inch and 16-inch DTBs, and copy artifacts back into build-output/.
- Result: The kernel compile flow is now a repeatable repository script instead of a fragile inline shell command.

## 2026-05-15T23:21:26+05:30

- Step name: Logged merge_config space issue
- Action: Recorded the kernel build failing because merge_config.sh split the workspace path at the space in /mnt/c/Users/GITWi/OneDrive/Documents/New project.
- Result: The build-script path-handling issue is documented before staging the config fragment into a space-safe location.

## 2026-05-15T23:21:40+05:30

- Step name: Hardened fragment staging
- Action: Updated scripts/build-book4edge-wsl.sh to copy configs/galaxy-book4-edge.fragment into the WSL output tree before calling merge_config.sh so the kernel merge step no longer depends on a workspace path that contains spaces.
- Result: The build entrypoint is now resilient to the repository path naming on Windows.

## 2026-05-15T23:22:12+05:30

- Step name: Logged missing awk dependency
- Action: Recorded the Book4 Edge kernel build failing inside merge_config.sh because the Fedora WSL environment did not have awk available on PATH.
- Result: The Kconfig helper dependency gap is documented before installing the missing package.

## 2026-05-15T23:23:04+05:30

- Step name: Logged DTB target naming issue
- Action: Recorded the out-of-tree kernel build failing because the DTB targets in scripts/build-book4edge-wsl.sh caused make to duplicate the arch/arm64/boot/dts path.
- Result: The compile target issue is documented before correcting the DTB target names.

## 2026-05-15T23:23:21+05:30

- Step name: Corrected DTB build targets
- Action: Updated scripts/build-book4edge-wsl.sh so the make invocation requests the Samsung DTBs by target name instead of by full output path.
- Result: The out-of-tree kernel build now uses the expected DTB target syntax.

## 2026-05-15T23:24:30+05:30

- Step name: Resolved repeated DTB target issue
- Action: Documented and evaluated multiple DTB target strategies after the same out-of-tree make error appeared twice, then updated scripts/build-book4edge-wsl.sh to use the canonical dtbs target and copy only the Samsung Book4 Edge DTBs from the completed output tree.
- Result: The kernel build now avoids ambiguous single-DTB target syntax.

## 2026-05-15T23:36:21+05:30

- Step name: Logged USB endpoint label mismatch
- Action: Recorded the DTB compile failure where x1-samsung-galaxy-book4-edge.dtsi referenced usb_1_ss0_dwc3 and usb_1_ss1_dwc3 labels that do not exist in the current hamoa-based upstream source tree.
- Result: The first DTS compile bug is documented before rebasing the endpoint references onto current upstream labels.

## 2026-05-15T23:37:07+05:30

- Step name: Rebased USB dr_mode references
- Action: Updated the patched WSL kernel source so the Book4 Edge dtsi sets dr_mode on &usb_1_ss0 and &usb_1_ss1, matching the labels used by current hamoa-based upstream X1 laptop DTS files.
- Result: The first DTS compile mismatch has been aligned with current upstream USB label naming.

## 2026-05-15T23:38:37+05:30

- Step name: Kernel artifacts verified
- Action: Confirmed that scripts/build-book4edge-wsl.sh produced build-output/Image.gz plus the Samsung Galaxy Book4 Edge 14-inch and 16-inch DTBs, and verified the DTB files are valid device tree blobs.
- Result: The repository now contains real build artifacts for the patched Book4 Edge kernel source.

## 2026-05-15T23:40:52+05:30

- Step name: Logged markdownlint regression
- Action: Recorded the renewed markdownlint failures after adding the build troubleshooting docs, including repeated MD013 pressure on exact-error captures and step-log entries.
- Result: The repeated Markdown validation class is documented before applying a durable formatting strategy.

## 2026-05-15T23:44:38+05:30

- Step name: Documentation lint hardening
- Action: Applied targeted markdownlint MD013 exemptions to machine-shaped build logs and exact error captures, added the repeated-error solution record, and normalized trailing blank lines in solution files.
- Result: The documentation now matches the operational logging workflow without weakening Markdown lint for normal prose.

## 2026-05-15T23:45:37+05:30

- Step name: Markdown lint cleanup
- Action: Removed trailing blank lines from solution notes, wrapped the long validator reproduction line in the markdownlint regression problem, and fenced the remaining long validation command block with a targeted MD013 exemption.
- Result: The remaining Markdown lint residues are isolated to content that can now be revalidated directly.

## 2026-05-15T23:46:04+05:30

- Step name: Build and docs validation
- Action: Re-ran npm Markdown lint and the Fedora WSL validation script after the Book4 Edge build and documentation hardening changes.
- Result: Both validation commands passed successfully, confirming the kernel build artifacts and updated documentation workflow are in a releasable state.

## 2026-05-15T23:46:28+05:30

- Step name: Source tree ignore guard
- Action: Added sources/ to .gitignore so the repository tracks the Book4 Edge build kit and produced artifacts without accidentally staging a local kernel source checkout.
- Result: The pending release now excludes workspace-only kernel source clones while preserving the reproducible build inputs and outputs.

## 2026-05-15T23:47:10+05:30

- Step name: Commit hook mailbox normalization
- Action: Documented the pre-commit stop caused by end-of-file and trailing-whitespace normalization on patches/galaxy-book4-edge-v5.mbox, then recorded the accepted remediation path of restaging the hook-adjusted mailbox before retrying the release commit.
- Result: The commit-gate formatting issue is now captured with both problem and solution records and is ready for a clean retry.

## 2026-05-15T23:48:11+05:30

- Step name: Remote publication check
- Action: Verified the repository has no configured remotes, captured the failed git push output, and documented the repeated publication blocker together with the non-destructive decision to stop before inventing a remote destination.
- Result: The release can be completed locally, but remote publication remains blocked until an explicit upstream URL is configured.

## 2026-05-15T23:48:37+05:30

- Step name: Local release tagged
- Action: Verified the release commit is clean, created the local Git tag v0.1.2, and confirmed that remote publication cannot proceed without a configured upstream.
- Result: The Book4 Edge build release now exists as a validated local commit and tag, ready to push once a real remote is configured.

## 2026-05-16T00:18:52+05:30

- Step name: Logged Docker engine outage
- Action: Captured the initial Docker failure where the installed Windows ARM client could not reach the desktop-linux engine pipe before attempting any Docker-based Linux environment setup.
- Result: The first Docker blocker is documented and ready for remediation.

## 2026-05-16T00:19:29+05:30

- Step name: Logged Docker service permission issue
- Action: Captured the direct Start-Service failure for com.docker.service from the non-elevated PowerShell session after confirming Docker Desktop itself could still be launched.
- Result: The service-control permission blocker is documented before switching to a user-space Docker Desktop startup path.

## 2026-05-16T00:22:51+05:30

- Step name: Docker build flow scaffolded
- Action: Added a Fedora Docker builder image, a container-native Book4 Edge kernel build script, a Windows PowerShell launcher for Docker Desktop, and updated the Book4 Edge patch plus release metadata for a Docker-first workflow.
- Result: The repository now contains a reproducible Docker-based Linux build path ready for execution and validation.

## 2026-05-16T00:31:20+05:30

- Step name: Logged Docker merge_config failure
- Action: Captured the first containerized build failure where merge_config.sh ended with 'No rule to make target alldefconfig' after being invoked outside the kernel source working directory.
- Result: The Docker build-script regression is documented before correcting the script.

## 2026-05-16T00:31:50+05:30

- Step name: Docker build script corrected
- Action: Updated the container build script to enter the kernel source tree before calling merge_config.sh and to apply the Book4 Edge patch with whitespace warnings suppressed so the stored patch can remain verbatim.
- Result: The containerized build flow now matches the working assumptions of the kernel config merge helper and is ready for another full run.

## 2026-05-16T00:39:54+05:30

- Step name: Docker build completed
- Action: Ran the new Fedora Docker launcher end to end, built the container image, refreshed the kernel source in Docker volumes, applied the rebased Book4 Edge patch, built Image.gz and dtbs, and verified the copied artifacts with the file utility.
- Result: The Linux-in-Docker build path now produces validated Book4 Edge kernel artifacts from this Windows workspace without using WSL.

## 2026-05-16T00:40:40+05:30

- Step name: Docker documentation lint cleanup
- Action: Wrapped the long Docker exact-error captures and command transcripts with targeted MD013 exemptions and reflowed the new merge_config regression note to keep the Docker troubleshooting docs markdownlint-compliant.
- Result: The Docker-specific documentation is ready for another validation pass.

## 2026-05-16T00:41:23+05:30

- Step name: Local Docker release tagged
- Action: Verified the repository still has no configured Git remotes, avoided repeating the known no-remote push failure, and created the local v0.1.3 tag for the Docker-based Book4 Edge build release.
- Result: The Docker release is complete as a validated local commit and tag and can be pushed immediately once an upstream remote is configured.

## 2026-05-16T00:43:14+05:30

- Step name: Docker workflow cleanup
- Action: Added a focused .dockerignore file, introduced a Docker validation helper, updated the builder image versioning, and removed the obsolete WSL-specific build entrypoints so Docker remains the only active Linux build path.
- Result: The repository now presents a cleaner Docker-first workflow with less build-context noise and less ambiguity about the supported environment.

## 2026-05-16T00:43:45+05:30

- Step name: Logged Docker validation exit-code bug
- Action: Captured the PowerShell validation helper incorrectly reporting success after docker image inspect failed because native Docker exit codes were not being checked explicitly.
- Result: The Docker validation regression is documented before fixing the script and rebuilding the expected image tag.

## 2026-05-16T00:52:16+05:30

- Step name: Docker workflow validation
- Action: Rebuilt the Docker builder image under the trimmed build context, refreshed the Book4 Edge artifacts, reran the fixed Docker validation helper, and reran Markdown lint for the repository docs.
- Result: The cleaned Docker-first workflow is validated end to end and ready for a local v0.1.4 release.

## 2026-05-16T00:52:34+05:30

- Step name: Local Docker cleanup release tagged
- Action: Created the local v0.1.4 tag for the Docker-first cleanup release after removing legacy WSL entrypoints and validating the stricter Docker helper behavior.
- Result: The repository now has a clean local v0.1.4 release that reflects the Docker-only active build path.

## 2026-05-16T21:46:14+05:30

- Step name: GitHub remote published
- Action: Added the provided GitHub repository as origin, pushed the current master branch, and pushed all local release tags through v0.1.4.
- Result: The project is now published to GitHub and future installer-workflow changes can be managed and shared through the remote repository.

## 2026-05-16T22:16:23+05:30

- Step name: Logged Fedora ISO download reset
- Action: Captured the failed Invoke-WebRequest attempt for the Fedora Workstation 44 aarch64 ISO after the remote host reset the connection during the large transfer.
- Result: The first installer-media download blocker is documented before switching to a more resilient fetch method.

## 2026-05-16T22:35:43+05:30

- Step name: aria2 installed
- Action: Installed aria2 on Windows through winget so large Fedora media downloads can use a visible progress bar plus multi-connection retry behavior.
- Result: The workspace now has an ISO download tool better suited to long transfers than Invoke-WebRequest or BITS.

## 2026-05-16T22:36:31+05:30

- Step name: Logged aria2 PATH issue
- Action: Captured the first aria2 invocation failure after installation because the current PowerShell session had not yet picked up the new aria2c PATH entry.
- Result: The aria2 bootstrap issue is documented before switching to an explicit executable path.

## 2026-05-16T22:59:10+05:30

- Step name: Download workflow inspection
- Action: Reviewed the repository state, changelog version, existing scripts, and the three new Fedora ISO download problem reports to scope the aria2 downloader work.
- Result: The next change set is narrowed to a scripted aria2 download path with progress output, solution records for the failed methods, and updated documentation.

## 2026-05-16T22:59:12+05:30

- Step name: Download workflow inspection
- Action: Reviewed the current repository state, existing documentation, changelog version, and the three new Fedora ISO download problem reports to prepare the aria2-based downloader changes.
- Result: The remaining work is now scoped to a scripted aria2 download path, solution records for the failed methods, and documentation updates around the new progress-enabled download flow.

## 2026-05-16T23:00:24+05:30

- Step name: aria2 downloader scripted
- Action: Added a reusable PowerShell downloader that finds aria2c automatically, downloads the Fedora Workstation aarch64 ISO with a visible progress bar, verifies SHA256, and documented the three resolved download failures plus the new workflow in the README and changelog.
- Result: The repository now contains a repeatable aria2-based installer-media download path instead of relying on fragile manual commands or default PowerShell transfer methods.

## 2026-05-16T23:02:52+05:30

- Step name: Logged downloader verification failures
- Action: Documented the new aria2 file-lock verification failure and the markdownlint line-length failures triggered by the download workflow documentation before attempting any fixes.
- Result: Both validation blockers now have exact error records under docs/problems and can be fixed without losing the original failure evidence.

## 2026-05-16T23:12:40+05:30

- Step name: aria2 download workflow validated
- Action: Fixed the downloader so an existing ISO is verified before any write attempt, cleaned the new problem and solution docs to satisfy markdownlint, reran the aria2-based Fedora ISO download script, and reran Markdown lint.
- Result: The repository now has a validated progress-enabled Fedora ISO download workflow that reuses the existing ISO safely and passes documentation linting cleanly.

## 2026-05-16T23:18:06+05:30

- Step name: Installer media base verified
- Action: Confirmed the downloaded Fedora Workstation aarch64 ISO is present under downloads and the Book4 Edge kernel artifacts are present under build-output before starting the custom USB workflow implementation.
- Result: The repository has the exact base inputs needed to build a patched Fedora installer staging tree from the official ISO plus the local Samsung kernel artifacts.

## 2026-05-16T23:20:54+05:30

- Step name: Patched USB staging workflow added
- Action: Added PowerShell helpers to build a local patched Fedora installer staging tree from the downloaded aarch64 ISO, inject the Book4 Edge kernel and DTBs, prepend custom GRUB entries, and mirror that staging tree onto a prepared USB drive.
- Result: The repository now has a concrete custom installer-media workflow built on top of the downloaded Fedora ISO instead of only documenting the idea.

## 2026-05-16T23:23:10+05:30

- Step name: Logged staging and README validation failures
- Action: Captured the failed local USB staging run caused by insufficient space in the OneDrive-backed repository path and recorded the new README markdownlint line-length failures before changing the workflow.
- Result: Both blockers are now documented under docs/problems so the staging path and README formatting can be corrected with the original failure evidence preserved.

## 2026-05-16T23:23:54+05:30

- Step name: Staging path and README fixes applied
- Action: Moved the default patched USB staging directory out of the OneDrive-backed repository into the local temp area, documented the staging-path and README-format alternatives, and wrapped the README USB workflow lines to stay within lint limits.
- Result: The custom installer workflow now avoids the repository storage bottleneck by default and the README changes are aligned with the repository Markdown policy.

## 2026-05-16T23:26:11+05:30

- Step name: Logged second-pass staging and doc failures
- Action: Recorded the second staging failure after moving the extracted Fedora live tree into the local temp directory and captured the remaining USB workflow markdownlint failures before changing strategy.
- Result: The repeated space error is now documented as a signal to pivot away from internal-drive staging, and the remaining doc-format issues are preserved for a targeted cleanup pass.

## 2026-05-16T23:31:56+05:30

- Step name: Logged direct writer strict-mode failure
- Action: Captured the first direct USB writer run failure after PowerShell strict mode rejected an unset LASTEXITCODE reference before any USB changes were made.
- Result: The direct writer bug is documented under docs/problems and the target USB remains untouched for a safe retry after the script fix.

## 2026-05-16T23:35:24+05:30

- Step name: Logged diskpart permission blocker
- Action: Recorded the direct USB writer failure when diskpart could not complete the USB reformat step in the current shell and documented the need for a non-elevated fallback path.
- Result: The new direct-writer blocker is preserved under docs/problems and the next fix can safely pivot to an in-place removable-drive workflow instead of retrying the same privileged operation.

## 2026-05-16T23:38:06+05:30

- Step name: Logged USB GRUB patch access issue
- Action: Captured the non-elevated direct USB writer failure after the Fedora live-media tree was mirrored onto D but the script could not rewrite grub.cfg because access to the copied file was denied.
- Result: The next direct-writer fix can target copied media attributes and file overwrite behavior with the exact USB-side failure documented first.

## 2026-05-16T23:39:10+05:30

- Step name: Logged GRUB template interpolation bug
- Action: Captured the direct USB writer failure after the in-place copy path reached custom GRUB entry generation and PowerShell tried to expand the literal GRUB root variable inside the here-string.
- Result: The remaining direct-writer bug is documented under docs/problems and can now be fixed by treating GRUB variables as literal text.

## 2026-05-16T23:41:10+05:30

- Step name: Direct patched USB created and verified
- Action: Completed the non-elevated direct USB workflow on D by mirroring the Fedora live-media tree, injecting the Book4 Edge kernel and DTBs, updating GRUB live-media label arguments to Eshank, and verifying the patched menu entries and boot assets on the USB.
- Result: The repository now has a validated direct patched Fedora USB creation path, and the current Eshank drive contains the patched installer media tree with Book4 Edge GRUB entries even though the shell could not repartition it into FAT32.
