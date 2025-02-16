//
//  ExamView.swift
//  Life@USTC (iOS)
//
//  Created by TiankaiMa on 2023/1/11.
//

import SwiftUI

private struct SingleExamView: View {
    let exam: Exam

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("\(exam.className)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .strikethrough(exam.isFinished)
                    Spacer()
                    Text("\(exam.typeName)")
                        .foregroundColor(Color.gray)
                        .font(.subheadline)
                }
                Text("\(exam.classIDString)")
                    .foregroundColor(Color.gray)
                    .font(.subheadline)
            }
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Image(systemName: "location.fill.viewfinder")
                    Text("\(exam.classRoomDistrict) \(exam.classRoomBuildingName) \(exam.classRoomName)")
                }
                .font(.callout)
                HStack {
                    Image(systemName: "calendar.badge.clock")
                    Text(exam.rawTime)
                    Spacer()
                    if exam.isFinished {
                        Text("Finished".localized)
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                    } else {
                        Text(exam.daysLeft == 1 ?
                            "1 day left".localized :
                            String(format: "%@ days left".localized, String(exam.daysLeft))
                        )
                        .foregroundColor(exam.daysLeft <= 7 ? .red : .accentColor)
                        .fontWeight(.bold)
                    }
                }
                .font(.callout)
            }
        }
    }
}

struct ExamView: View {
    var body: some View {
        NavigationStack {
            AsyncView(delegate: ExamDelegate.shared) {
                exams in
                ScrollView(showsIndicators: false) {
                    ForEach(exams) { exam in
                        SingleExamView(exam: exam)
                        Divider()
                    }
                    .padding(.top, 25)
                }
                .padding(.horizontal, 25)
                .toolbar {
                    AsyncButton(bigStyle: false) {
                        try await Exam.saveToCalendar(exams)
                    } label: { _ in
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
            .navigationBarTitle("Exam", displayMode: .inline)
        }
    }
}

struct ExamView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SingleExamView(exam: .example)
        }
        .listStyle(.inset)
    }
}
