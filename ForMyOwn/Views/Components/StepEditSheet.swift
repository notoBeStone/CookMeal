import SwiftUI

struct StepEditSheet: View {
    @Binding var stepEditMode: StepEditMode
    @Binding var newStep: StepModel
    let recipeId: UUID
    var onAdd: () -> Void
    var onUpdate: () -> Void
    
    var body: some View {
        NavigationStack {
            StepEditView(step: $newStep, recipeId: recipeId)
                .padding()
                .navigationTitle(stepEditMode == .adding ? "添加步骤" : "编辑步骤")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("取消") {
                            newStep = StepModel()
                            stepEditMode = .none
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(stepEditMode == .adding ? "添加" : "保存") {
                            if case .adding = stepEditMode {
                                onAdd()
                            } else if case .editing = stepEditMode {
                                onUpdate()
                            }
                            stepEditMode = .none
                        }
                        .disabled(newStep.description.isEmpty)
                    }
                }
        }
        .presentationDetents([.medium])
    }
}
