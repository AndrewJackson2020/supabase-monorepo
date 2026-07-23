{
  pkgs ? import <nixpkgs> { }, build ? "master", build_type ? "autoconf",
}:
let
  pgbouncer_native_build_inputs = [
    pkgs.pkg-config
    pkgs.cmake
    pkgs.gcc
    pkgs.postgresql
    pkgs.libpq
  ];
  pgbouncer_build_inputs = [
    pkgs.openldap
    pkgs.automake
    pkgs.autoconf
    pkgs.c-ares
    pkgs.meson
    pkgs.ninja
    pkgs.act
    pkgs.curl
    pkgs.cacert
    pkgs.libevent
    pkgs.libtool
    pkgs.openssl
    pkgs.pam
    pkgs.socat
    pkgs.pandoc
    pkgs.which
    pkgs.git
    pkgs.ruff
    pkgs.python313
    pkgs.python313Packages.pip
    pkgs.python313Packages.pytest
    pkgs.python313Packages.pytest-xdist
    pkgs.python313Packages.pytest-asyncio
    pkgs.python313Packages.pytest-timeout
    pkgs.python313Packages.filelock
    pkgs.python313Packages.psycopg
    pkgs.postgresql
  ];
  builds = {
    master = {
      url = "https://github.com/pgbouncer/pgbouncer.git";
      rev = "master";
    };
    gss = {
      url = "https://github.com/AndrewJackson2020/pgbouncer.git";
      rev = "gss";
    };
  };
  uncrustify = pkgs.stdenv.mkDerivation {
      name = "uncrustify";
      src = builtins.fetchGit {
        url = "https://github.com/uncrustify/uncrustify.git";
        ref = "refs/tags/uncrustify-0.77.1";
      };
      dontUseCmakeConfigure = true;
      nativeBuildInputs = [
        pkgs.cmake
        pkgs.automake
        pkgs.python313
      ];
      buildInputs = [ 
	pkgs.cmake
        pkgs.automake
        pkgs.python313
      ];
      doCheck = false;
      configurePhase = ''
        mkdir build
      '';
      buildPhase = "cd build &&  cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$out/ ..";
      installPhase = "make install";
  };
  autoconf_build = pkgs.stdenv.mkDerivation {
      name = "pgbouncer";
      src = builtins.fetchGit {
        url = builds."${build}".url;
        ref = builds."${build}".rev;
      };
      dontUseCmakeConfigure = true;
      nativeBuildInputs = pgbouncer_native_build_inputs ++ [ uncrustify ];
      buildInputs = pgbouncer_build_inputs ++ [ uncrustify ];
      # checks not working for some tests
      doCheck = true;
      checkPhase = ''
        make check
      '';
      shellHook = ''
        export TMPDIR=/tmp
        export TMP=/tmp
      '';
      configurePhase = ''
        	      ./autogen.sh
        	      ./configure \
			--with-pam \
			--with-ldap \
			--with-cares \
		      	--prefix=$out/
      '';
      buildPhase = "make -j";
      installPhase = "make install";
  };
  meson_build = pkgs.stdenv.mkDerivation {
      name = "pgbouncer";
      src = builtins.fetchGit {
        url = builds."${build}".url;
        ref = builds."${build}".rev;
      };
      dontUseCmakeConfigure = true;
      nativeBuildInputs = pgbouncer_native_build_inputs;
      buildInputs = pgbouncer_build_inputs;
      configurePhase = ''
        	      ./autogen.sh
        	      ./configure \
			--with-pam \
			--with-ldap \
			--with-cares \
		      	--prefix=$out/
      '';
      buildPhase = "make -j";
      installPhase = "make install";
  };
  build_type_map = {
    autoconf = autoconf_build;
    meson = meson_build;
  };
in
{
    package = build_type_map."${build_type}";
    devshell = pkgs.mkShell {
      nativeBuildInputs = [
        pkgs.pkg-config
      ];
      buildInputs = [
        pkgs.openssl
      ];
    };
}
