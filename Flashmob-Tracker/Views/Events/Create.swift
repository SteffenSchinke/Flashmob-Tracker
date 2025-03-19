//
//  CreateEvent.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 24.02.25.
//


import SwiftUI

struct Create: ContentView {
    
    @Namespace private var createSpace
    
    @Environment(MapVM.self) private var mapVM
    @Environment(PDFFileVM.self) private var pdfVM
    @Environment(MediaFileVM.self) private var mediaVM
    @Environment(EventVM.self) private var eventVM
    @Environment(\.dismiss) private var dismiss
    
    @State private var isExpanded1: Bool = false
    @State private var isExpanded2: Bool = false
    @State private var isExpanded3: Bool = false
    @State private var isExpanded4: Bool = false
    @State private var isExpanded5: Bool = false
    @State private var isExpanded6: Bool = false
    @State private var referenceCounter: Int = 0
    
    var localKey: String = "title_create_event"
    var headerMode: HeaderDisplayMode = .visible
    var isViewModelinWorking: Bool { self.eventVM.isWorking }
    var sourceViewNamespace: Namespace.ID? { self.createSpace }
    
    
    init() {
        
        print("Create view init() ...")
    }
    
    var content: some View {
        
        @Bindable var eventVM = self.eventVM
           
        VStack {
            
            Form {
               
                Section {
                    
                    DisclosureGroup(
                        isExpanded: $isExpanded1,
                        content: {
                            Group {
                                
                                BorderTextField($eventVM.title,
                                                "ph_title", "tip_tilte") {
                                    
                                    self.eventVM.isTitleValid()
                                }
                                
                                BorderTextField($eventVM.motto,
                                                "ph_motto", "tip_motto") {
                                    
                                    self.eventVM.isMottoValid()
                                }
                                
                                BorderTextField($eventVM.desc,
                                                "ph_desc", "tip_desc") {
                                    
                                    self.eventVM.isDescriptionValid()
                                }
                            }
                            .listRowBackground(Color.clear)},
                        label: {
                            Label(self.appLang.localString("title_desc"),
                                  systemImage: SFIcon.text.key)
                        })
                }
                .listRowSeparator(.hidden, edges: .all)
                .listRowBackground(isExpanded1 ?
                                   Color.gray.opacity(0.3) :
                                    Color.clear)
                
                Section {
                    
                    DisclosureGroup(
                        isExpanded: $isExpanded2,
                        content: {
                            
                            DatePicker(
                                "",
                                selection: $eventVM.selectedDate,
                                in: Calendar.current.date(byAdding: .day, value: 21, to: Date())!...,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(.graphical)
                            .listRowBackground(Color.clear)
                        },
                        label: {
                            Label(self.appLang.localString("title_date"),
                                  systemImage: SFIcon.cal.key)
                        })
                }
                .listRowSeparator(.hidden, edges: .all)
                .listRowBackground(isExpanded2 ?
                                   Color.gray.opacity(0.3) :
                                    Color.clear)
                
                Section {
                    
                    DisclosureGroup(
                        isExpanded: $isExpanded3,
                        content: {
                            
                            VStack {
                                
                                MapRect(.constant(true),
                                        .constant(false),
                                        .constant(false),
                                        .constant(false),
                                        .constant(true),
                                        self.sourceViewNamespace!) { location in
                                            
                                            self.eventVM.event?.location = location
                                        }
                                .cornerRadius(16)
                                .frame(height: 300)
                                .padding(.top, 32)
                            }
                            .listRowBackground(Color.clear)
                        },
                        label: {
                            Label(self.appLang.localString("title_location"),
                                  systemImage: SFIcon.mappin_map.key)
                        })
                }
                .listRowSeparator(.hidden, edges: .all)
                .listRowBackground(isExpanded3 ?
                                   Color.gray.opacity(0.3) :
                                    Color.clear)
                
                
                Section {
                    
                    DisclosureGroup(
                        isExpanded: $isExpanded4,
                        content: {
                            
                            VStack(spacing: 20) {
                                HStack {
                                    
                                    Text(self.appLang.localString("title_actors"))
                                        .font(.callout)
                                        .frame(maxWidth: 140, alignment: .leading)
                                    
                                    TextField("", value: $eventVM.maxActorCount,
                                              formatter: NumberFormatter())
                                        .keyboardType(.numberPad)
                                        .borderTextFieldStyle()
                                        .frame(width: 60)
                                        .multilineTextAlignment(.center)
                                    
                                    Stepper("", value: $eventVM.maxActorCount, in: 1...10000)
                                        .labelsHidden()
                                }
                                .padding(.top, 30)
                                
                                HStack {
                                    
                                    Text(self.appLang.localString("title_actors_search"))
                                        .font(.callout)
                                        .frame(maxWidth: 140, alignment: .leading)
                                    
                                    TextField("", value: $eventVM.searchActorCount,
                                              formatter: NumberFormatter())
                                        .borderTextFieldStyle()
                                        .keyboardType(.numberPad)
                                        .frame(width: 60)
                                        
                                    let range = 1...eventVM.maxActorCount
                                    Stepper("", value: $eventVM.searchActorCount, in: range)
                                        .labelsHidden()
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .listRowBackground(Color.clear)
                        },
                        label: {
                            Label(self.appLang.localString("title_planned_team"),
                                  systemImage: SFIcon.team.key)
                        })
                }
                .listRowSeparator(.hidden, edges: .all)
                .listRowBackground(isExpanded4 ?
                                   Color.gray.opacity(0.3) :
                                    Color.clear)
                
                Section {
                    
                    DisclosureGroup(
                        isExpanded: $isExpanded5,
                        content: {
                            
                            MediaFile()
                                .padding(.top, 10)
                                .listRowBackground(Color.clear)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        },
                        label: {
                            Label(self.appLang.localString("title_motiv"),
                                  systemImage: SFIcon.flame.key)
                        })
                }
                .listRowSeparator(.hidden, edges: .all)
                .listRowBackground(isExpanded5 ?
                                   Color.gray.opacity(0.3) :
                                    Color.clear)
                
                Section {
                    
                    DisclosureGroup(
                        isExpanded: $isExpanded6,
                        content: {
                            
                            PDFFile()
                                .padding(.top, 10)
                                .listRowBackground(Color.clear)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        },
                        label: {
                            Label(self.appLang.localString("title_docs"),
                                  systemImage: SFIcon.doc.key)
                        })
                }
                .listRowSeparator(.hidden, edges: .all)
                .listRowBackground(isExpanded6 ?
                                   Color.gray.opacity(0.3) :
                                    Color.clear)
                    
            }
            .padding(.bottom, 40)
            .frame(maxHeight: .infinity)
            .scrollContentBackground(.hidden)
            .foregroundStyle(.black.opacity(
                colorScheme == .dark ? 0.9 : 0.6))
            .task {
                
                if self.referenceCounter == 0 {
                    
                    print("Create view onAppear() action ...")
                    
                    self.referenceCounter += 1
                    self.eventVM.createTempEvent()
                }
            }
            .onDisappear {
                
                print("Create view onDisappear() action ...")
            }
            .alert(appLang.localString(eventVM.errorMessage),
                   isPresented: $eventVM.hasError) {}
            
            ButtonRect("btn_save") {
                
                if self.eventVM.isFormConform() {
                    
                    self.eventVM.insertEvent()
                    dismiss()
                }
            }
            .padding(.bottom, 40)
        }
    }
    
    func getLeadingMenu() -> EmptyView  { EmptyView() }
    func getTrailingMenu() -> AnyView  {
        
        AnyView(
            
            ButtonDismiss() {
                
                print("Create view dismiss() action ...")
                
                self.eventVM.deleteTempEvent()
                self.referenceCounter -= 1
            }
        )
    }
    
    private func formattedDate(_ date: Date) -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        
        return formatter.string(from: date)
    }
}
