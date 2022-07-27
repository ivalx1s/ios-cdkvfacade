import SwiftUI


@main
struct ckcdApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


struct ContentView: View {
    let store: IDBStore = IoC.DBStore
    @State private var contacts: [Contact] = []
    @State private var msgs: [ChatMsg] = []
    @State private var prefs: UserPrefs = .defaultValue

    var body: some View {
        VStack {
            Toggle(isOn: $prefs.notificationsAllowed) {
                Text("Enable Notifications")
            }
                    .onChange(of: prefs) { newPrefs in store.userPrefs.setPrefs(newPrefs)}
                    .onAppear { self.prefs = store.userPrefs.getPrefs() }
            List {
                Section(header: Text("Msgs")) {
                    ForEach(msgs, id: \.id) { m in
                        Text("ID: \(m.id), fk: \(m.chatId) txt:  \(m.msg)")
                    }
                }

                Section(header: Text("Contacts")) {
                    ForEach(contacts, id: \.id) { c in
                        Text("ID: \(c.id) nameL \(c.name)")
                    }
                }
            }

            Button("Add new contact") {
                    let contactId = Int.random(in: 0...Int.max)
                    try! store.contacts.upsert([.init(id: contactId, name: "Contact-Hui-\(contactId)", createDate: .now)])
                    contacts = try! store.contacts.readAll()
            }

            Button("Add new msg") {
                let msgId = Int.random(in: 0...Int.max)
                let chatId = 100
                try! store.chatMsgs.upsert(.init(id: msgId, chatId: chatId, msg: "Chat msg: \(msgId)", createDate: .now))
                msgs = try! store.chatMsgs.readAll()
            }
        }
        .task {
            Task {
                contacts = try! store.contacts.readAll()
                msgs = try! store.chatMsgs.readAll(foreignKey: 100.description)
            }
        }
    }
}
