.class public interface abstract Lcom/hook/packageinstaller/profiles/InstallerProfile;
.super Ljava/lang/Object;
.source "InstallerProfile.java"


# virtual methods
.method public abstract classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;
.end method

.method public abstract fingerprintMatches(Ljava/lang/ClassLoader;)Z
.end method

.method public abstract id()Ljava/lang/String;
.end method

.method public abstract label()Ljava/lang/String;
.end method

.method public abstract matches(Lcom/hook/packageinstaller/core/InstallerVersion;Ljava/lang/ClassLoader;)Z
.end method

.method public abstract specificity()I
.end method

.method public abstract versionHintMatches(Lcom/hook/packageinstaller/core/InstallerVersion;)Z
.end method
