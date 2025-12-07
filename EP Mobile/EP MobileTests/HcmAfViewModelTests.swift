import Testing
@testable import EP_Mobile

@Suite("HcmAfViewModel Tests")
@MainActor
struct HcmAfViewModelTests {
    @Test("initial state is correct")
    func initialStateIsCorrect() async throws {
        let vm = HcmAfViewModel()
        #expect(vm.resultState == "Enter values to see result.")
    }

    @Test("valid inputs produce success state with expected contents")
    func validInputsProduceSuccess() async throws {
        let vm = HcmAfViewModel()
        // Act
        vm.onLaDiameterChanged("40")
        vm.onAgeAtEvalChanged("50")
        vm.onAgeAtDxChanged("35")
        vm.onHfSxChanged(true)
        vm.calculate()

        // Assert
        let text = vm.resultState
        #expect(text.contains("HCM-AF Score: 29"))
        #expect(text.contains("High risk (>2.0%/y)"))
        #expect(text.contains("5-Year AF Risk: 39.3%"))
    }

    @Test("out-of-range LA diameter produces the correct error message")
    func laDiameterOutOfRangeProducesError() async throws {
        let vm = HcmAfViewModel()
        // Arrange valid others
        vm.onAgeAtEvalChanged("50")
        vm.onAgeAtDxChanged("35")
        vm.onHfSxChanged(true)
        // Act
        vm.onLaDiameterChanged("99")
        vm.calculate()
        // Assert
        #expect(vm.resultState == "Error: LA Diameter must be between 24 and 65 mm.")
    }

    @Test("non-numeric input produces parsing error message")
    func nonNumericInputProducesParsingError() async throws {
        let vm = HcmAfViewModel()
        vm.onAgeAtEvalChanged("abc")
        vm.calculate()
        #expect(vm.resultState == "Please enter all values.")
    }

    @Test("clear resets all fields and result state")
    func clearResetsState() async throws {
        let vm = HcmAfViewModel()
        vm.onLaDiameterChanged("40")
        vm.onAgeAtEvalChanged("50")
        vm.onAgeAtDxChanged("35")
        vm.onHfSxChanged(true)
        vm.calculate()
        // Ensure it changed
        #expect(vm.resultState != "Enter values to see result.")
        // Now clear
        vm.clear()
        #expect(vm.laDiameterInput == "")
        #expect(vm.ageAtEvalInput == "")
        #expect(vm.ageAtDxInput == "")
        #expect(vm.hfSxChecked == false)
        #expect(vm.resultState == "Enter values to see result.")
    }
}
