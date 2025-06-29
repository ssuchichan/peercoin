package=openssl
$(package)_version=1.1.1t
$(package)_download_path=https://www.openssl.org/source
$(package)_file_name=$(package)-$($(package)_version).tar.gz
$(package)_sha256_hash=8dee9b24bdb1dcbf0c3d1e9b02fb8f6bf22165e807f45adeb7c9677536859d3b

define $(package)_set_vars
$(package)_config_env=AR="$($(package)_ar)" RANLIB="$($(package)_ranlib)" CC="$($(package)_cc)"
$(package)_config_opts=--prefix=$(host_prefix) --openssldir=$(host_prefix)/etc/openssl
$(package)_config_opts+=no-camellia
$(package)_config_opts+=no-capieng
$(package)_config_opts+=no-cast
$(package)_config_opts+=no-comp
$(package)_config_opts+=no-dso
$(package)_config_opts+=no-dtls1
$(package)_config_opts+=no-ec_nistp_64_gcc_128
$(package)_config_opts+=no-engine
$(package)_config_opts+=no-gost
$(package)_config_opts+=no-heartbeats
$(package)_config_opts+=no-idea
$(package)_config_opts+=no-md2
$(package)_config_opts+=no-mdc2
$(package)_config_opts+=no-rc4
$(package)_config_opts+=no-rc5
$(package)_config_opts+=no-rdrand
$(package)_config_opts+=no-rfc3779
$(package)_config_opts+=no-sctp
$(package)_config_opts+=no-seed
$(package)_config_opts+=no-shared
$(package)_config_opts+=no-sock
$(package)_config_opts+=no-ssl-trace
$(package)_config_opts+=no-ssl2
$(package)_config_opts+=no-ssl3
$(package)_config_opts+=no-tests
$(package)_config_opts+=no-unit-test
$(package)_config_opts+=no-weak-ssl-ciphers
$(package)_config_opts+=no-whirlpool
$(package)_config_opts+=no-zlib
$(package)_config_opts+=no-zlib-dynamic
$(package)_config_opts+=$(subst c11,gnu89,$($(package)_cflags)) $($(package)_cppflags)
$(package)_config_opts_linux=-fPIC -Wa,--noexecstack
$(package)_config_opts_x86_64_linux=linux-x86_64
$(package)_config_opts_i686_linux=linux-generic32
$(package)_config_opts_arm_linux=linux-generic32
$(package)_config_opts_armv7l_linux=linux-generic32
#$(package)_config_opts_aarch64_darwin=linux-generic64
$(package)_config_opts_aarch64_linux=linux-generic64
$(package)_config_opts_mipsel_linux=linux-generic32
$(package)_config_opts_mips_linux=linux-generic32
$(package)_config_opts_powerpc_linux=linux-generic32
$(package)_config_opts_riscv32_linux=linux-generic32
$(package)_config_opts_riscv64_linux=linux-generic64
$(package)_config_opts_x86_64_darwin=darwin64-x86_64-cc
$(package)_config_opts_x86_64_mingw32=mingw64
$(package)_config_opts_i686_mingw32=mingw
ifeq ($(host_os)_$(host_arch),darwin_aarch64)
$(package)_config_opts:=darwin64-arm64-cc no-asm
else
$(package)_config_opts+=$($(package)_config_opts_$(host_os)_$(host_arch))
endif
endef

define $(package)_preprocess_cmds
  sed -i.old "s/define DATE .*/define DATE \"\"/g" util/mkbuildinf.pl
endef

define $(package)_config_cmds
  WINDRES=$($(host_os)_WINDRES) ./Configure $($(package)_config_opts)
endef

define $(package)_build_cmds
  $(MAKE) -j$(JOBS) build_libs
endef

define $(package)_stage_cmds
  sed -i.old "s/^INSTALLTOP=/INSTALLTOP?=/g" Makefile && \
  $($(package)_stage_env) $(MAKE) INSTALLTOP=$($(package)_staging_dir)/$(host_prefix) install_sw && \
  find $($(package)_staging_dir)/$(host_prefix)/lib -name "*.so*" -delete 2>/dev/null || true && \
  find $($(package)_staging_dir)/$(host_prefix)/lib -name "*.dylib*" -delete 2>/dev/null || true
endef

define $(package)_postprocess_cmds
  rm -rf share bin etc
endef
