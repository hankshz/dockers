setup:
	fn apps create testapp
	(cd apps/go; fn build; fn routes create testapp /go-test)
	(cd apps/python3; fn build; fn routes create testapp /python3-test)
	(cd apps/nodejs; fn build; fn routes create testapp /nodejs-test)

clean:
	fn routes delete testapp /go-test || true
	fn routes delete testapp /python3-test || true
	fn routes delete testapp /nodejs-test || true
	fn apps delete testapp

.PHONY: setup clean
