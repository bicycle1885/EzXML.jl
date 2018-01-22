using BinaryProvider

# This is where all binaries will get installed
prefix = Prefix(!isempty(ARGS) ? ARGS[1] : joinpath(@__DIR__, "usr"))

# Instantiate products here.  Examples:
libxml2 = LibraryProduct(prefix, "libxml2")

# Assign products to `products`:
products = [libxml2]

# Download binaries from hosted location
bin_prefix = "https://github.com/bicycle1885/XML2Builder/releases/download/v0.1.0"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    BinaryProvider.Linux(:aarch64, :glibc) => ("$bin_prefix/XML2Builder.aarch64-linux-gnu.tar.gz", "71b748413ed15af6e8103ce92ef6815c21ac246fd552cb751c7c8fdf5baf6a22"),
    BinaryProvider.Linux(:armv7l, :glibc) => ("$bin_prefix/XML2Builder.arm-linux-gnueabihf.tar.gz", "6238259551eef6a29685263a8c87656f0a1caff32e695ce70dabfebee8272ed2"),
    BinaryProvider.Linux(:i686, :glibc) => ("$bin_prefix/XML2Builder.i686-linux-gnu.tar.gz", "8f626a01da78eda11d0f44e967064c6817ea25b6ec0a664eabc5527557d309b5"),
    BinaryProvider.Windows(:i686) => ("$bin_prefix/XML2Builder.i686-w64-mingw32.tar.gz", "f84592972d7dd3dbd015e5adb0157cedd8edf1afd4f4bb8ab148009713f4d24e"),
    BinaryProvider.Linux(:powerpc64le, :glibc) => ("$bin_prefix/XML2Builder.powerpc64le-linux-gnu.tar.gz", "0d25d19d4584b97a8ab29d1525425893bab1732f58246f9cfb8a443f92adb87a"),
    BinaryProvider.MacOS() => ("$bin_prefix/XML2Builder.x86_64-apple-darwin14.tar.gz", "c32b58b51a569a19fa364cd0e2a304aff3cd77c24f1380d9d0f55a271d3fc354"),
    BinaryProvider.Linux(:x86_64, :glibc) => ("$bin_prefix/XML2Builder.x86_64-linux-gnu.tar.gz", "e708282bdfbf232feaeb5168effd70cad58a3b0ab4e9dcb6b479ec473c1071e5"),
    BinaryProvider.Windows(:x86_64) => ("$bin_prefix/XML2Builder.x86_64-w64-mingw32.tar.gz", "bece194e7598328d56af66a97181d735d9c2ff1ccfbf3ccd0177c34b59382734"),
)
if platform_key() in keys(download_info)
    # First, check to see if we're all satisfied
    if any(!satisfied(p; verbose=true) for p in products)
        # Download and install binaries
        url, tarball_hash = download_info[platform_key()]
        install(url, tarball_hash; prefix=prefix, force=true, verbose=true)
    end

    # Finally, write out a deps.jl file that will contain mappings for each
    # named product here: (there will be a "libxml2" variable and a "xml2ifier"
    # variable, etc...)
    @write_deps_file libxml2
else
    error("Your platform $(Sys.MACHINE) is not supported by this package!")
end
