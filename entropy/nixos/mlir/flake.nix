{
  description = "Custom-Built MLIR";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" ]; #"x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });

    in

    {

      # A Nixpkgs overlay.
      overlay = final: prev: {

        mlir = with final; llvmPackages_14.stdenv.mkDerivation rec {
          name = "mlir-${version}";

          #readOnlySrc = ./.;

          #src = ./.;
          #src = runCommand "${name}-src-${version}" {} (''
            #mkdir -p "$out"
            #cp -r ${readOnlySrc}/cmake "$out"
            #cp -r ${readOnlySrc}/llvm "$out"
            #cp -r ${readOnlySrc}/third-party "$out"
          #'');
          
          src = fetchFromGitHub {
            owner = "llvm";
            repo = "llvm-project";
            rev = "49caf7012170422afa84868598063818f9344228";
            sha256 = "sha256-j+ladpx8NfJGszj17oRkgvb4U2race+2DTKLtRZGeUM=";
          };

          sourceRoot = "source/llvm";

          nativeBuildInputs = [
            python3
            ninja
            cmake
            ncurses
            zlib
            #pkg-config
            llvmPackages_14.llvm
            llvmPackages_14.clang
            llvmPackages_14.bintools
          ];

          buildInputs = [ libxml2 ];

          #propagatedBuildInputs = [ ncurses zlib ];

          # where to find libgcc
          #NIX_LDFLAGS="-L${gccForLibs}/lib/gcc/${targetPlatform.config}/${gccForLibs.version}"; # -L ${zlib}/lib";
          # teach clang about C startup file locations
          #CFLAGS="-B${gccForLibs}/lib/gcc/${targetPlatform.config}/${gccForLibs.version} -B ${stdenv.cc.libc}/lib";

          #LD_LIBRARY_PATH="${zlib}/lib:${ncurses}/lib:$LD_LIBRARY_PATH";

          cmakeFlags = [
            # "-DGCC_INSTALL_PREFIX=${gcc}"
            #"-DC_INCLUDE_DIRS=${stdenv.cc.libc.dev}/include"
            "-GNinja"
            # Debug for debug builds
            "-DCMAKE_BUILD_TYPE=Release"
            # from the original LLVM expr
            "-DLLVM_LINK_LLVM_DYLIB=ON"
            # inst will be our installation prefix
            #"-DCMAKE_INSTALL_PREFIX=../inst"
            # "-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON"
            # change this to enable the projects you need
            "-DLLVM_ENABLE_PROJECTS=mlir"
            "-DLLVM_BUILD_EXAMPLES=ON"
            # this makes llvm only to produce code for the current platform, this saves CPU time, change it to what you need
            "-DLLVM_TARGETS_TO_BUILD=X86"
#            -DLLVM_TARGETS_TO_BUILD="X86;NVPTX;AMDGPU" \
            "-DLLVM_ENABLE_ASSERTIONS=ON"
            # Using clang and lld speeds up the build, we recomment adding:
            "-DCMAKE_C_COMPILER=clang"
            "-DCMAKE_CXX_COMPILER=clang++"
            "-DLLVM_ENABLE_LLD=ON"
            #"-DLLVM_USE_LINKER=${llvmPackages_14.bintools}/bin/lld"
            # CCache can drastically speed up further rebuilds, try adding:
            #"-DLLVM_CCACHE_BUILD=ON"
            # libxml2 needs to be disabled because the LLVM build system ignores its .la
            # file and doesn't link zlib as well.
            # https://github.com/ClangBuiltLinux/tc-build/issues/150#issuecomment-845418812
            #"-DLLVM_ENABLE_LIBXML2=OFF"
          ];
        };

      };

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
        {
          inherit (nixpkgsFor.${system}) mlir;
        });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.mlir);

      # A NixOS module, if applicable (e.g. if the package provides a system service).
      nixosModules.mlir =
        { pkgs, ... }:
        {
          nixpkgs.overlays = [ self.overlay ];

          environment.systemPackages = [ pkgs.mlir ];

          #systemd.services = { ... };
        };

    };
}

