module

public import StateCheck00
public import StateCheck01
public import StateCheck02
public import StateCheck03
public import StateCheck04
public import StateCheck05
public import StateCheck06
public import StateCheck07
public import StateCheck08
public import StateCheck09
public import StateCheck10
public import StateCheck11
public import StateCheck12
public import StateCheck13
public import StateCheck14
public import StateCheck15
public import StateCheck16
public import StateCheck17
public import StateCheck18
public import StateCheck19
public import StateCheck20
public import ClassCheck00
public import ClassCheck01
public import ClassCheck02
public import ClassCheck03
public import ClassCheck04
public import ClassCheck05
public import ClassCheck06
public import ClassCheck07
public import ClassCheck08
public import ClassCheck09
public import ClassCheck10
public import ClassCheck11
public import ClassCheck12
public import ClassCheck13
public import ClassCheck14

@[expose] public section
set_option maxRecDepth 32768
set_option maxHeartbeats 16000000
namespace Couret
namespace Certificate

theorem all_state_facts : ∀ i : StateId, StateFacts i := by
  exact (Fin.cases (state_row_0) (Fin.cases (state_row_1) (Fin.cases (state_row_2) (Fin.cases (state_row_3) (Fin.cases (state_row_4) (Fin.cases (state_row_5) (Fin.cases (state_row_6) (Fin.cases (state_row_7) (Fin.cases (state_row_8) (Fin.cases (state_row_9) (Fin.cases (state_row_10) (Fin.cases (state_row_11) (Fin.cases (state_row_12) (Fin.cases (state_row_13) (Fin.cases (state_row_14) (Fin.cases (state_row_15) (Fin.cases (state_row_16) (Fin.cases (state_row_17) (Fin.cases (state_row_18) (Fin.cases (state_row_19) (Fin.cases (state_row_20) (Fin.cases (state_row_21) (Fin.cases (state_row_22) (Fin.cases (state_row_23) (Fin.cases (state_row_24) (Fin.cases (state_row_25) (Fin.cases (state_row_26) (Fin.cases (state_row_27) (Fin.cases (state_row_28) (Fin.cases (state_row_29) (Fin.cases (state_row_30) (Fin.cases (state_row_31) (Fin.cases (state_row_32) (Fin.cases (state_row_33) (Fin.cases (state_row_34) (Fin.cases (state_row_35) (Fin.cases (state_row_36) (Fin.cases (state_row_37) (Fin.cases (state_row_38) (Fin.cases (state_row_39) (Fin.cases (state_row_40) (Fin.cases (state_row_41) (Fin.cases (state_row_42) (Fin.cases (state_row_43) (Fin.cases (state_row_44) (Fin.cases (state_row_45) (Fin.cases (state_row_46) (Fin.cases (state_row_47) (Fin.cases (state_row_48) (Fin.cases (state_row_49) (Fin.cases (state_row_50) (Fin.cases (state_row_51) (Fin.cases (state_row_52) (Fin.cases (state_row_53) (Fin.cases (state_row_54) (Fin.cases (state_row_55) (Fin.cases (state_row_56) (Fin.cases (state_row_57) (Fin.cases (state_row_58) (Fin.cases (state_row_59) (Fin.cases (state_row_60) (Fin.cases (state_row_61) (Fin.cases (state_row_62) (Fin.cases (state_row_63) (Fin.cases (state_row_64) (Fin.cases (state_row_65) (Fin.cases (state_row_66) (Fin.cases (state_row_67) (Fin.cases (state_row_68) (Fin.cases (state_row_69) (Fin.cases (state_row_70) (Fin.cases (state_row_71) (Fin.cases (state_row_72) (Fin.cases (state_row_73) (Fin.cases (state_row_74) (Fin.cases (state_row_75) (Fin.cases (state_row_76) (Fin.cases (state_row_77) (Fin.cases (state_row_78) (Fin.cases (state_row_79) (Fin.cases (state_row_80) (Fin.cases (state_row_81) (Fin.cases (state_row_82) (Fin.cases (state_row_83) (Fin.cases (state_row_84) (Fin.cases (state_row_85) (Fin.cases (state_row_86) (Fin.cases (state_row_87) (Fin.cases (state_row_88) (Fin.cases (state_row_89) (Fin.cases (state_row_90) (Fin.cases (state_row_91) (Fin.cases (state_row_92) (Fin.cases (state_row_93) (Fin.cases (state_row_94) (Fin.cases (state_row_95) (Fin.cases (state_row_96) (Fin.cases (state_row_97) (Fin.cases (state_row_98) (Fin.cases (state_row_99) (Fin.cases (state_row_100) (Fin.cases (state_row_101) (Fin.cases (state_row_102) (Fin.cases (state_row_103) (Fin.cases (state_row_104) (Fin.cases (state_row_105) (Fin.cases (state_row_106) (Fin.cases (state_row_107) (Fin.cases (state_row_108) (Fin.cases (state_row_109) (Fin.cases (state_row_110) (Fin.cases (state_row_111) (Fin.cases (state_row_112) (Fin.cases (state_row_113) (Fin.cases (state_row_114) (Fin.cases (state_row_115) (Fin.cases (state_row_116) (Fin.cases (state_row_117) (Fin.cases (state_row_118) (Fin.cases (state_row_119) (Fin.cases (state_row_120) (Fin.cases (state_row_121) (Fin.cases (state_row_122) (Fin.cases (state_row_123) (Fin.cases (state_row_124) (Fin.cases (state_row_125) (Fin.cases (state_row_126) (Fin.cases (state_row_127) (Fin.cases (state_row_128) (Fin.cases (state_row_129) (Fin.cases (state_row_130) (Fin.cases (state_row_131) (Fin.cases (state_row_132) (Fin.cases (state_row_133) (Fin.cases (state_row_134) (Fin.cases (state_row_135) (Fin.cases (state_row_136) (Fin.cases (state_row_137) (Fin.cases (state_row_138) (Fin.cases (state_row_139) (Fin.cases (state_row_140) (Fin.cases (state_row_141) (Fin.cases (state_row_142) (Fin.cases (state_row_143) (Fin.cases (state_row_144) (Fin.cases (state_row_145) (Fin.cases (state_row_146) (fun i => Fin.elim0 i))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

theorem all_class_facts : ∀ c : ClassId, ClassFacts c := by
  exact (Fin.cases (class_row_0) (Fin.cases (class_row_1) (Fin.cases (class_row_2) (Fin.cases (class_row_3) (Fin.cases (class_row_4) (Fin.cases (class_row_5) (Fin.cases (class_row_6) (Fin.cases (class_row_7) (Fin.cases (class_row_8) (Fin.cases (class_row_9) (Fin.cases (class_row_10) (Fin.cases (class_row_11) (Fin.cases (class_row_12) (Fin.cases (class_row_13) (Fin.cases (class_row_14) (Fin.cases (class_row_15) (Fin.cases (class_row_16) (Fin.cases (class_row_17) (Fin.cases (class_row_18) (Fin.cases (class_row_19) (Fin.cases (class_row_20) (Fin.cases (class_row_21) (Fin.cases (class_row_22) (Fin.cases (class_row_23) (Fin.cases (class_row_24) (Fin.cases (class_row_25) (Fin.cases (class_row_26) (Fin.cases (class_row_27) (Fin.cases (class_row_28) (Fin.cases (class_row_29) (Fin.cases (class_row_30) (Fin.cases (class_row_31) (Fin.cases (class_row_32) (Fin.cases (class_row_33) (Fin.cases (class_row_34) (Fin.cases (class_row_35) (Fin.cases (class_row_36) (Fin.cases (class_row_37) (Fin.cases (class_row_38) (Fin.cases (class_row_39) (Fin.cases (class_row_40) (Fin.cases (class_row_41) (Fin.cases (class_row_42) (Fin.cases (class_row_43) (Fin.cases (class_row_44) (Fin.cases (class_row_45) (Fin.cases (class_row_46) (Fin.cases (class_row_47) (Fin.cases (class_row_48) (Fin.cases (class_row_49) (Fin.cases (class_row_50) (Fin.cases (class_row_51) (Fin.cases (class_row_52) (Fin.cases (class_row_53) (Fin.cases (class_row_54) (Fin.cases (class_row_55) (Fin.cases (class_row_56) (Fin.cases (class_row_57) (Fin.cases (class_row_58) (Fin.cases (class_row_59) (Fin.cases (class_row_60) (Fin.cases (class_row_61) (Fin.cases (class_row_62) (Fin.cases (class_row_63) (Fin.cases (class_row_64) (Fin.cases (class_row_65) (Fin.cases (class_row_66) (Fin.cases (class_row_67) (Fin.cases (class_row_68) (Fin.cases (class_row_69) (Fin.cases (class_row_70) (Fin.cases (class_row_71) (Fin.cases (class_row_72) (Fin.cases (class_row_73) (Fin.cases (class_row_74) (Fin.cases (class_row_75) (Fin.cases (class_row_76) (Fin.cases (class_row_77) (Fin.cases (class_row_78) (Fin.cases (class_row_79) (Fin.cases (class_row_80) (Fin.cases (class_row_81) (Fin.cases (class_row_82) (Fin.cases (class_row_83) (Fin.cases (class_row_84) (Fin.cases (class_row_85) (Fin.cases (class_row_86) (Fin.cases (class_row_87) (Fin.cases (class_row_88) (Fin.cases (class_row_89) (Fin.cases (class_row_90) (Fin.cases (class_row_91) (Fin.cases (class_row_92) (Fin.cases (class_row_93) (Fin.cases (class_row_94) (Fin.cases (class_row_95) (Fin.cases (class_row_96) (Fin.cases (class_row_97) (Fin.cases (class_row_98) (Fin.cases (class_row_99) (Fin.cases (class_row_100) (fun i => Fin.elim0 i))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

theorem initial_encoding : entry 0 = none := by decide
theorem quotient_initial : classOf 0 = 0 := by decide
theorem locate_entry (i : StateId) : locateState (entry i) = i := (all_state_facts i).2.2.1
theorem entry_injective (i j : StateId) (h : entry i = entry j) : i = j := by
  have he := congrArg locateState h
  simpa only [locate_entry] using he
theorem only_initial (i : StateId) : entry i = none ↔ i = 0 := (all_state_facts i).2.2.2.1
theorem transitions_checked (i : StateId) (g : Symbol) : StepValid (entry i) (entry (tableNext i g)) g := (all_state_facts i).2.2.2.2.1 g
theorem reachability_checked (i : StateId) : tableRun 0 (reachWord i) = i := (all_state_facts i).2.2.2.2.2.1
theorem nonempty_witness_checked (i : StateId) (h : i ≠ 0) : (reachWord i).nonempty := (all_state_facts i).2.2.2.2.2.2.1 h
theorem observation_checked (i : StateId) : tableOutput i = outputMask (entry i) ∧ tableOutput i = presenceCount (entry i) := ⟨(all_state_facts i).2.2.2.2.2.2.2.1,(all_state_facts i).2.2.2.2.2.2.2.2.1⟩
theorem quotient_congruence_checked (i : StateId) (g : Symbol) : classOf (tableNext i g) = quotientNext (classOf i) g := (all_state_facts i).2.2.2.2.2.2.2.2.2.1 g
theorem quotient_output_checked (i : StateId) : tableOutput i = quotientOutput (classOf i) := (all_state_facts i).2.2.2.2.2.2.2.2.2.2
theorem representatives_checked (c : ClassId) : classOf (representative c) = c := (all_class_facts c).2.2.1
theorem separating_words_checked (c d : ClassId) (h : c ≠ d) : quotientOutput (quotientRun c (separatingWord c d)) ≠ quotientOutput (quotientRun d (separatingWord c d)) := (all_class_facts c).2.2.2.1 d h
theorem separating_length_checked (c d : ClassId) : wordLength (separatingWord c d) ≤ 2 := (all_class_facts c).2.2.2.2 d
theorem data_bounds : (∀ i : StateId, ∀ g : Symbol, nextNat i g < 147) ∧ (∀ i : StateId, classNat i < 101) ∧ (∀ c : ClassId, ∀ g : Symbol, quotientNextNat c g < 101) ∧ (∀ c : ClassId, representativeNat c < 147) := ⟨fun i => (all_state_facts i).1,fun i => (all_state_facts i).2.1,fun c => (all_class_facts c).1,fun c => (all_class_facts c).2.1⟩

end Certificate
end Couret
