# Konfiguracja
IMAGE_NAME := murvudd/python-mongo
IMAGE_NAME_UND := murvudd/python_mongo

VERSION_FILE := VERSION
CURRENT_VERSION := $(shell cat $(VERSION_FILE))

# Logika podbijania wersji (0.X -> 0.X+1)
# Wykorzystujemy awk, aby zwiększyć ostatnią cyfrę po kropce
NEXT_VERSION := $(shell echo $(CURRENT_VERSION) | awk -F. '{print $$1"."$$2+1}')

.PHONY: all build release push bump

all: build

# 1. Budowanie obrazu z aktualną wersją
build:
	@echo "Building version $(CURRENT_VERSION)..."
	docker build -t $(IMAGE_NAME):$(CURRENT_VERSION) .

# 2. Podbicie wersji w pliku VERSION
bump:
	@echo "Bumping version: $(CURRENT_VERSION) -> $(NEXT_VERSION)"
	@echo $(NEXT_VERSION) > $(VERSION_FILE)

# 3. Tagowanie jako latest i push do Docker Hub
push:
	@echo "Tagging and pushing version $(CURRENT_VERSION)..."
	docker tag $(IMAGE_NAME):$(CURRENT_VERSION) $(IMAGE_NAME):latest
	docker tag $(IMAGE_NAME):$(CURRENT_VERSION) $(IMAGE_NAME_UND):$(CURRENT_VERSION)
	docker tag $(IMAGE_NAME_UND):$(CURRENT_VERSION) $(IMAGE_NAME_UND):latest

	docker push $(IMAGE_NAME):$(CURRENT_VERSION)
	docker push $(IMAGE_NAME_UND):$(CURRENT_VERSION)

	docker push $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME_UND):latest

# 4. Git commit i tag
git-tag:
	#$(CURRENT_VERSION) is evaluated from VERSION file, if release bump has happened. if tagging raw, takes current ver.
	@echo "Creating Git tag for version $(CURRENT_VERSION)..."
	git add $(VERSION_FILE)
	git commit -m "Bump version to $(CURRENT_VERSION)"
	git tag -a "v$(CURRENT_VERSION)" -m "Release version $(CURRENT_VERSION)"
	@echo "Don't forget to run 'git push origin main --tags'"
	git push
	git push --tags

# 5. Pełny cykl: build -> tag/push -> bump wersji na następny raz
release: bump build push git-tag
	@echo "Release $(CURRENT_VERSION) finished. Next version will be $(NEXT_VERSION)."

# Pomocnicza komenda do testowania lokalnego (build + run)
run: build
	docker run -it --rm $(IMAGE_NAME):$(CURRENT_VERSION)