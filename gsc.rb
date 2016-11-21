class Gsc < Formula
  desc "The Guide Star Catalog I"
  homepage "http://gsss.stsci.edu"
  url "http://cdsarc.u-strasbg.fr/viz-bin/nph-Cat/tar.gz?bincats/GSC_1.2"

  # not sure this won't change - they might update.
  # If this starts failing I will have to disable the sha
  #
  # sha256 "7f9a25155b47e625db3460a3f9da500b851da7847c388f4dea93aa7c98d0cef1"
  # Can't have the sha because the download is dynamic


  def gen_osx_make
    osxmake = <<OSX_MAKE
include makefile

install_osx: $(PGMS) genreg.exe phase2
	mkdir -p ../bin
	mv gsc.exe    ../bin/gsc
	mv decode.exe   ../bin/decode
	./genreg.exe -b -c -d
OSX_MAKE

    File.write("Makefile.osx", osxmake)
  end

  def install
    cd "src/" do
      gen_osx_make
      system "make", "-f", "Makefile.osx"
      system "make", "-f", "Makefile.osx", "install_osx", "GSCDAT=#{pwd}/.."
    end

    mkdir bin
    system "cp -r N* S* #{prefix}/"

    cp "./bin/gsc", "#{bin}/"
    cp "./bin/decode", "#{bin}/"
    cp "./bin/regions.ind", "#{bin}/"
    cp "./bin/regions.bin", "#{bin}/"
  end

  test do
    system "GSCDAT=#{prefix}", "gsc", "-c", "111+2"
  end
end
