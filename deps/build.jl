using BinaryProvider

# Configure the binary dependency.
prefix = Prefix(!isempty(ARGS) ? ARGS[1] : joinpath(@__DIR__, "usr"))
libxml2 = LibraryProduct(prefix, "libxml2", :libxml2)
products = [libxml2]
bin_prefix = "https://github.com/bicycle1885/XML2Builder/releases/download/v1.0.0"
download_info = Dict(
    BinaryProvider.Linux(:aarch64, :glibc)     => ("$bin_prefix/XML2Builder.aarch64-linux-gnu.tar.gz", "cc64013edbf308f1d26e02b05b29c2072545276122884024a2e79871c4f23be6"),
    BinaryProvider.Linux(:armv7l, :glibc)      => ("$bin_prefix/XML2Builder.arm-linux-gnueabihf.tar.gz", "08c1b599aeda68e1783479b147e68a79224167ba4f693f431d02f734523b11a5"),
    BinaryProvider.Linux(:i686, :glibc)        => ("$bin_prefix/XML2Builder.i686-linux-gnu.tar.gz", "f6a076cfa78cc04f782428e23f1492b8c583fcf3d177a1b7eea206721666cecb"),
    BinaryProvider.Linux(:powerpc64le, :glibc) => ("$bin_prefix/XML2Builder.powerpc64le-linux-gnu.tar.gz", "2c04d6dd67107b933ed5fb2b2afd50892b6f3a94bdf2412604a49654f033947b"),
    BinaryProvider.Linux(:x86_64, :glibc)      => ("$bin_prefix/XML2Builder.x86_64-linux-gnu.tar.gz", "d3125723e5c75ded1eb01e5ce06c7dfae149ee276aa2d3f82a64edb2e8df23b8"),
    BinaryProvider.MacOS()                     => ("$bin_prefix/XML2Builder.x86_64-apple-darwin14.tar.gz", "c29fc38446b74830ce26d135974cc5043b636e0fe350bfa0e26e166edcebd7b7"),
    BinaryProvider.Windows(:i686)              => ("$bin_prefix/XML2Builder.i686-w64-mingw32.tar.gz", "d09490cc615b541c236485b170007911587501ee8c3a3e3edc8d054e5412553c"),
    BinaryProvider.Windows(:x86_64)            => ("$bin_prefix/XML2Builder.x86_64-w64-mingw32.tar.gz", "37f5b9d4df9e919a196dacbc2ede80b75a3aae7058890701958925336d145fb6"),
)

# Download and install it.
if platform_key() in keys(download_info)
    if any(!satisfied(p; verbose=true) for p in products)
        url, tarball_hash = download_info[platform_key()]
        install(url, tarball_hash; prefix=prefix, force=true, verbose=true)
    end
    write_deps_file(joinpath(@__DIR__, "deps.jl"), products)
else
    error("Your platform $(Sys.MACHINE) is not supported by this package!")
end
