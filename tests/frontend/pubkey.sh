#! /usr/bin/env atf-sh

. $(atf_get_srcdir)/test_environment.sh

tests_init \
	pubkey \
	pubkey_legacy

# New format, prefix the key type
pubkey_body() {
	atf_check -o save:repo.pub -e ignore \
		pkg key --create repo.key
	mkdir fakerepo

	cat >> test.ucl << EOF
name: test
origin: test
version: "1"
maintainer: test
categories: [test]
comment: a test
www: http://test
prefix: /
abi = "*";
desc: <<EOD
Yet another test
EOD
EOF

	atf_check -o ignore -e ignore \
		pkg create -M test.ucl -o fakerepo
	atf_check -o ignore -e ignore \
		pkg repo fakerepo rsa:repo.key
	cat >> repo.conf << EOF
local: {
	url: file:///${TMPDIR}/fakerepo
	enabled: true
	pubkey: ${TMPDIR}/repo.pub
	signature_type: "pubkey"
}
EOF
	atf_check \
		-o ignore \
		pkg -o REPOS_DIR="${TMPDIR}" \
		-o ${PKG_CACHEDIR}="${TMPDIR}" update
}

# Legacy format, unprefixed key passed to pkg-repo
pubkey_legacy_body() {
	atf_check -o save:repo.pub -e ignore \
		pkg key --create repo.key
	mkdir fakerepo

	cat >> test.ucl << EOF
name: test
origin: test
version: "1"
maintainer: test
categories: [test]
comment: a test
www: http://test
prefix: /
abi = "*";
desc: <<EOD
Yet another test
EOD
EOF

	atf_check -o ignore -e ignore \
		pkg create -M test.ucl -o fakerepo
	atf_check -o ignore -e ignore \
		pkg repo fakerepo repo.key
	cat >> repo.conf << EOF
local: {
	url: file:///${TMPDIR}/fakerepo
	enabled: true
	pubkey: ${TMPDIR}/repo.pub
	signature_type: "pubkey"
}
EOF
	atf_check \
		-o ignore \
		pkg -o REPOS_DIR="${TMPDIR}" \
		-o ${PKG_CACHEDIR}="${TMPDIR}" update
}

