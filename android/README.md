# React Native Android Integration Models

## 1. Standard React Native App (node_modules)

- All JavaScript and native dependencies (Hermes, React-Android, etc.) are included in the `node_modules` directory.
- Android build (`build.gradle`) directly references AARs, .so files, and resources from `node_modules`.
- Host app builds with all code locally; no external dependency management for native code beyond npm/yarn.
- Upgrading or changing dependencies is done via `package.json` and npm/yarn.

```
+-----------------------+
|   Host Android App    |
|   (React Native App)  |
+-----------------------+
            |
            v
+----------------------------+
|    node_modules folder     |
|  (all JS & native deps)    |
+----------------------------+
            |
            v
+----------------------------+
|   build.gradle dependencies|
|  (local AARs & .so files)  |
+----------------------------+
            |
            v
+----------------------------+
|       Output APK/AAB       |
| (built with all dependencies) |
+----------------------------+
```

**Pros:**
- Simple for development.

**Cons:**
- Harder to share code as a reusable SDK/framework.
- Host app always has to carry full React Native infrastructure.
- Dependency management and updates require npm/yarn (not Gradle/Maven).

---

## 2. Maven-based Modular Integration (AAR per dependency)

- Each major dependency (Hermes, React-Android, 3rd party native modules) is built as a separate AAR and published to a Maven repository.
- The RN integration is distributed as a prebuilt AAR (framework), which declares dependencies on all needed native modules via Maven (in `build.gradle`).
- The Host App adds the RN integration AAR as a Gradle dependency; Gradle automatically resolves and fetches all required AARs from Maven.
- No need for local `node_modules` in the host app; all native code comes from Maven artifacts.

```
+-----------------------+
|   Host Android App    |
|  (your native app)    |
+-----------------------+
            |
            v
     +------------------+
     |   RN Integration |
     |      (.aar)      |
     +------------------+
       /     |     |    \
      v      v     v     v
+-----------+ +-------------+ +-------------+ +-----------------+
| Hermes    | | React-      | | Onfido      | | Other Native    |
| Engine    | | Android Core| | SDK (.aar)  | | Module (.aar)   |
|  (.aar)   | |   (.aar)    | |             | | (from node_modules)|
+-----------+ +-------------+ +-------------+ +-----------------+
```

**Pros:**
- Much easier integration with existing native apps (just add dependencies in Gradle).
- Clear separation between host app and framework/dependencies.\

**Cons:**
- More complex initial setup for publishing and versioning AARs.


