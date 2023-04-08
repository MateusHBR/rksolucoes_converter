.PHONY: download-packages
download-packages:
	git clone git@github.com:MateusHBR/rk_parser.git ./packages/rk_parser

.PHONY: generate_bridge
generate_bridge:
	flutter_rust_bridge_codegen \
    -r packages/rk_parser/src/api.rs \
    -d lib/bridge_generated.dart \
    -c ios/Runner/bridge_generated.h \
    -e macos/Runner/

.PHONY: setup
setup:
	@rm -rf packages/
	@$(MAKE) download-packages
	@$(MAKE) generate_bridge