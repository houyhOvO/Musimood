//
//  PlaylistsView.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/13.
//

import SwiftUI
import SwiftData


struct PlaylistsView: View {
    @Query private var playlists: [Playlist]
    @Environment(\.modelContext) private var context
    
    @State private var isShowingAddSheet = false
    @State private var newPlaylistTitle = ""
    @State private var isEditing = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var playlistBeingRenamed: Playlist? = nil
    @State private var renamedTitle: String = ""
    
    var body: some View {
        List {
            ForEach(playlists) { playlist in
                NavigationLink {
                    SongsView(playlist: playlist)
                } label: {
                    HStack {
                        Image(systemName: "music.note.list")
                            .foregroundStyle(.secondary)
                        Text(playlist.name)
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        context.delete(playlist)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button {
                        playlistBeingRenamed = playlist
                        renamedTitle = playlist.name
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
            .onDelete(perform: deletePlaylist)
            .onMove(perform: movePlaylist)
        }
        .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(isEditing ? "Done" : "Edit") {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        isEditing.toggle()
                    }
                }
                .contentTransition(.identity)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        
        .sheet(isPresented: $isShowingAddSheet) {
            NewPlaylistSheet(
                title: $newPlaylistTitle,
                onSave: {
                    if !newPlaylistTitle.isEmpty {
                        context.insert(Playlist(name: newPlaylistTitle))
                        newPlaylistTitle = ""
                    }
                }
            )
            .presentationDetents([.large])
        }
        .sheet(item: $playlistBeingRenamed) { playlist in
            NewPlaylistSheet(
                title: $renamedTitle,
                onSave: {
                    playlist.name = renamedTitle
                },
                sheetTitle: "Rename Playlist"
            )
        }
    }
    
    private func deletePlaylist(at offsets: IndexSet) {
        for index in offsets {
            context.delete(playlists[index])
        }
    }
    
    private func movePlaylist(from source: IndexSet, to destination: Int) {
        var reordered = playlists
        reordered.move(fromOffsets: source, toOffset: destination)
    }
    
    private func showingRenameSheet(for playlist: Playlist) {
        playlistBeingRenamed = playlist
        renamedTitle = playlist.name
    }
    
    private func renamePlaylist() {
        guard let playlist = playlistBeingRenamed else { return }
        playlist.name = renamedTitle
        playlistBeingRenamed = nil
    }
}

struct NewPlaylistSheet: View {
    @Binding var title: String
    var onSave: () -> Void
    var sheetTitle: String = "New Playlist"
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.quaternary)
                            .frame(width: 120, height: 120)
                            .overlay {
                                Image(systemName: "music.note.list")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.secondary)
                            }
                        
                        Text("Add Artwork")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }
                
                Section {
                    TextField("Playlist Name", text: $title)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                }
            }
            .navigationTitle(sheetTitle)
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onSave()
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
