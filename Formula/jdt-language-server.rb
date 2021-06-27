class JdtLanguageServer < Formula
  desc "Eclipse JDT Language Server"
  homepage "https://github.com/eclipse/eclipse.jdt.ls"
  url "https://download.eclipse.org/jdtls/snapshots/jdt-language-server-1.2.0-202106220411.tar.gz"
  sha256 "d695476416a9ea48de5aaedacf8efccc6a0a66c15745ee28242dd884d9a55808"

  depends_on "openjdk"

  def install
    rm_rf "config_linux"
    rm_rf "config_win"
    libexec.install ["config_mac", "features", "plugins"]
    (bin/"jdt-language-server").write <<~EOS
      #!/bin/bash
      JDT_LS_HOME="#{libexec}"
      JDT_LS_LAUNCHER=$(find $JDT_LS_HOME -name "org.eclipse.equinox.launcher_*.jar")
      JDT_LS_HEAP_SIZE=${JDT_LS_HEAP_SIZE:=-Xmx12G}
      JAVA_BIN="$(brew --prefix)/opt/openjdk/bin/java"
      exec ${JAVA_BIN} -Declipse.application=org.eclipse.jdt.ls.core.id1 -Dosgi.bundles.defaultStartLevel=4 -Declipse.product=org.eclipse.jdt.ls.core.product -Dlog.protocol=true -Dlog.level=ALL -noverify $JDT_LS_HEAP_SIZE -jar "$JDT_LS_LAUNCHER" -configuration "$JDT_LS_HOME/config_mac" --add-modules=ALL-SYSTEM --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED -data "$HOME/workspace"
    EOS
  end
end
