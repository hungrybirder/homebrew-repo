class JdtLanguageServer < Formula
  desc "Eclipse JDT Language Server"
  homepage "https://github.com/eclipse/eclipse.jdt.ls"
  url "https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-1.26.0-202307200157.tar.gz"
  sha256 "626cdffe93dcf8c2869783de02e784f0028aede286d6eef930553c68c04e74cc"

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
    (bin/"java-lsp").write <<~EOS
      #!/bin/bash
      JDT_LS_HOME="#{libexec}"
      JDT_LS_LAUNCHER=$(find $JDT_LS_HOME -name "org.eclipse.equinox.launcher_*.jar")
      JDT_LS_HEAP_SIZE=${JDT_LS_HEAP_SIZE:=-Xmx12G}
      JAVA_BIN="java"
      GRADLE_HOME="$(brew --prefix)/opt/gradle"
      export GRADLE_HOME
      exec $JAVA_BIN \
        -Declipse.application=org.eclipse.jdt.ls.core.id1 \
        -Dosgi.bundles.defaultStartLevel=4 \
        -Declipse.product=org.eclipse.jdt.ls.core.product \
        -Dlog.protocol=true \
        -Dlog.level=ALL \
        $JDT_LS_HEAP_SIZE \
        -jar "$JDT_LS_LAUNCHER" \
        -configuration "$JDT_LS_HOME/config_mac" \
        -data "$1" \
        --add-modules=ALL-SYSTEM \
        --add-opens java.base/java.util=ALL-UNNAMED \
        --add-opens java.base/java.lang=ALL-UNNAMED
    EOS
  end
end
