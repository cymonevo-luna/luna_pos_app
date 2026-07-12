.PHONY: ci
ci:
	@test -f .env || cp .env.example .env
	flutter pub get
	flutter analyze
	flutter test
