module

public import RankData

@[expose] public section
set_option maxRecDepth 100000
set_option maxHeartbeats 4000000
namespace Couret
namespace S5
def RankFacts (m : Nat) : Prop := rank m ≤ 5 ∧ (rank m = 5 ↔ maskSupport m (0,0)) ∧ ∀ g : Code30, min (rank m + 1) 5 ≤ rank (subStep m g)
theorem rank_row_0 : RankFacts 0 := by unfold RankFacts; decide +kernel
theorem rank_row_1 : RankFacts 1 := by unfold RankFacts; decide +kernel
theorem rank_row_2 : RankFacts 2 := by unfold RankFacts; decide +kernel
theorem rank_row_3 : RankFacts 3 := by unfold RankFacts; decide +kernel
theorem rank_row_4 : RankFacts 4 := by unfold RankFacts; decide +kernel
theorem rank_row_5 : RankFacts 5 := by unfold RankFacts; decide +kernel
theorem rank_row_6 : RankFacts 6 := by unfold RankFacts; decide +kernel
theorem rank_row_7 : RankFacts 7 := by unfold RankFacts; decide +kernel
theorem rank_row_8 : RankFacts 8 := by unfold RankFacts; decide +kernel
theorem rank_row_9 : RankFacts 9 := by unfold RankFacts; decide +kernel
theorem rank_row_10 : RankFacts 10 := by unfold RankFacts; decide +kernel
theorem rank_row_11 : RankFacts 11 := by unfold RankFacts; decide +kernel
theorem rank_row_12 : RankFacts 12 := by unfold RankFacts; decide +kernel
theorem rank_row_13 : RankFacts 13 := by unfold RankFacts; decide +kernel
theorem rank_row_14 : RankFacts 14 := by unfold RankFacts; decide +kernel
theorem rank_row_15 : RankFacts 15 := by unfold RankFacts; decide +kernel
end S5
end Couret
