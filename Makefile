.PHONY: ci codegen-verify
ci:
	@test -f .env || cp .env.example .env
	flutter pub get
	@bash scripts/verify-codegen.sh
	flutter analyze
	flutter test

codegen-verify:
	@bash scripts/verify-codegen.sh
