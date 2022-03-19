app:
	stack --docker --local-bin-path=./bin install --ghc-options '-optl-static -fPIC -optc-Os'

image: app
	docker build -t ${tag} . --build-arg local_bin_path=./bin -f Dockerfile
