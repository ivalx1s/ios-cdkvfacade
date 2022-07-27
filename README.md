# CoreDataKVFacade

A simple facade for CoreData with built-in Key-Value storage implementation. Syncs nicely with CloudKit through NSPersistentCloudKitContainer.



## CDKVFacadeSample

A sample app that demostrates the use of the facade.

Edit `CDKVFacadeSample.xcodeprojless` manifest to specify:

- your Development Team ID
- random iCloud container
- random boundle identifier


```
Root -> settings -> base -> DEVELOPMENT_TEAM
```

```
Root -> targets -> app-ios -> entitlements -> properties -> com.apple.developer.icloud-container-identifiers
```

```
Root -> settings -> base -> PROJECT_BUNDLE_ID_PREFIX
```



Use [Xcodegen](https://github.com/yonaskolb/XcodeGen) to generate the Xcode project:

```
cd path/to/package/directory
```

```
./.xcgen
```


## ToDo:

- [ ] observe db changes to propagate updates to UI in real time
- [ ] background updates
