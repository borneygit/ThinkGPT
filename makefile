clean:
	@melos clean

gen_res:
	@melos run gen_res

build_shared:
	@melos run build:shared
build_data:
	@melos run build:data
build_domain:
	@melos run build:domain
build_app:
	@melos run build:app

build: build_shared build_domain build_data build_app

watch_shared:
	@melos run watch:shared
watch_data:
	@melos run watch:data
watch_domain:
	@melos run watch:domain
watch_app:
	@melos run watch:app


analyze:
	@melos run analyze
analyze_app:
	@melos run analyze:app
analyze_data:
	@melos run analyze:data
analyze_domain:
	@melos run analyze:domain
analyze_shared:
	@melos run analyze:shared




