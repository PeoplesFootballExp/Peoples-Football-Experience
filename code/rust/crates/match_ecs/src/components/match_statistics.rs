#[derive(Component)]
pub struct AttackingStats {
    // The number of goals scored by the player into the opponent's net.
    pub goals: u16,

    // A pre-shot probability metric (from 0.0 to 1.0) that calculates the likelihood of a goal being scored before a shot is taken.
    // It measures the quality of the chance created.
    pub expected_goals: f32,

    // A post-shot probability metric (from 0.0 to 1.0) that calculates the likelihood of a goal being scored after a shot is taken.
    // It measures the quality of the shot itself. Higher numbers usually means the shot was in harder to save regions and closer to goal
    pub expected_goals_on_target: f32,

    // The total number of shots intentially taken by the player.
    pub total_shots: u16,

    // The number of intentional shots taken by the player that would (or did) result in a goal without a save by a
    // goalkeeper or defender. In other words, the shot was heading into net
    pub shots_on_target: u16,

    // The number of shots from outside the penalty box taken by the player.
    pub shots_outside_box: u16,

    // The number of times the player touches the ball in the opposition's box. The higher the number, the more attacking
    // presence the player has.
    pub touches_in_opposition_box: u16,

    // The number of times the player attempted to dribble the ball.
    pub attempted_dribbles: u16,

    // The number of times the player successfully dribbled the ball.
    pub successful_dribbles: u16,

    // The number of times the player is reasonably expected to score (open net, 1v1 with GK) but fails to convert.
    pub big_chances_missed: u16,

    // Number of times the player was offside
    pub offsides: u16,

    // The number of times the player attempted a penalty
    pub attempted_penalties: u16,

    // The number of times the player successfully scored a penalty
    pub successful_penalties: u16,

    // The number of penalties won by the player.
    pub penalties_won: u16,

    // The number of times a shot from the player hit the post or crossbar
    pub shots_hit_woodwork: u16,
}

#[derive(Component)]
pub struct PassingStats {
    // This is simply the number of times the player touches the ball.
    pub touches: u16,

    // The number of times the player accurately passed the ball to a teammate.
    pub accurate_passes: u16,

    // The total number of passes attempted by the player to a teammate.
    pub passes_attempted: u16,

    // The number of times the player accurately passed the ball to a teammate that directly leads to a
    // teammate scoring a goal.
    pub assist: u16,

    // The number of times the player accurately attempted a long ball to a teammate.
    pub accurate_long_balls: u16,

    // The number of times the player attempted a long ball to a teammate.
    pub long_balls_attempted: u16,

    // This evaluates the quality of a pass. It represents the likelihood that the pass will become an assist, based
    // on the xG of the shot that directly follows it.
    pub expected_assists: f32,

    // The number of passes that directly lead to a teammate shooting a shot.
    pub key_passes: u16,

    // The number of chances the player created. This is the summation of the player's assists and key passes.
    pub chances_created: u16,

    // The number of passes that end up in the final third of the field.
    pub passes_into_final_third: u16,

    // The number of passes that end up in the penalty area.
    pub passes_into_penalty_area: u16,

    // Number of Progressive passes that moved the ball toward the opponents goal by more than 10 yards.
    pub progressive_passes: u16,

    // The number of crosses attempted by the player
    pub crosses_attempted: u16,

    // The number of times the player successfully crosses the ball.
    pub crosses_completed: u16,

    // The number of times the player was dispossessed by an opponent without a foul occuring
    pub dispossessed: u16,

    // The number of times the player created a big chance for a teammate to score (1v1 with GK, open net, etc)
    pub big_chances: u16,

    // The number of corners taken by the player
    pub corners_taken: u16,
}

#[derive(Component)]
pub struct DefensiveStats {
    // The number of attempted tackles by the player.
    pub tackles_attempted: u16,

    // The number of times the player successfully tackles the ball.
    pub tackles_completed: u16,

    // The number of interceptions by the player.
    pub interceptions: u16,

    // The number of times the player used their body or legs to stop an opponent's shot or cross from
    // taveling toward the goal/box
    pub blocks: u16,

    // The number of times the player regains possession from a loose ball
    pub recoveries: u16,

    // The number of times the player kicks or heads the ball away from their own defensive third
    // to relieve pressure, without specifically aiming for a teammate
    pub clearances: u16,

    // The number of times the player specifically clears the ball with their head.
    pub head_clearances: u16,

    // The number of times the player is dribbled past by an opponent in a 1v1 encounter
    pub dribbled_past: u16,

    // The number of own goals scored by the player
    pub own_goals: u16,

    // The number of yellow cards in the game
    pub yellow_cards: u16,

    // Tracks if the player was given a red card in the game. For statistical purposeses, it will be a number
    pub red_cards: u16,
}

#[derive(Component)]
pub struct DuelsStats {
    // The number of duels attempted by the player
    pub duels_attempted: u16,

    // The number of duels won by the player
    pub duels_won: u16,

    // The number of duels on the ground won by the player
    pub ground_duels_won: u16,

    // The number of duels on the ground attempted by the player
    pub ground_duels_attempted: u16,

    // The number of duels in the air won by the player
    pub aerial_duels_won: u16,

    // The number of duels in the air attempted by the player
    pub aerial_duels_attempted: u16,

    // The number of fouls committed by the player
    pub fouls_committed: u16,

    // The number of times the player was fouled by an opponent
    pub times_fouled: u16,
}

#[derive(Component)]
pub struct GoalKeepingStats {
    // The number of shots saved. This is defined as the number of times the goalkeeper saves a SHOT ON TARGET. Meaning, the ball would've
    // went in the net and counted as a goal HAD the goalkeeper not saved it.
    pub saves: u16,

    // The number of goals conceded. This is simply the number of goals scored while the goalkeeper was on the field.
    pub goals_conceded: u16,

    // Expected goals on Target. This statistics measures the quality of a shot after it is taken. For goalkeepers, this statistic
    // is added together
    pub xgot_faced: f32,

    // The number of goals prevented by the goalkeeper
    pub goals_prevented: f32,

    // The number of times the goalkeeper acted as a sweeper, coming out of the penalty area to defend or provide a passing option
    pub acted_as_sweeper: u16,

    // The number of times the goalkeeper claimed a high claim, such as a corner or a free kick
    pub high_claim: u16,

    // The number of penalties the goalkeeper had to face
    pub penalties_faced: u16,

    // The number of times the goalkeeper saved a penalty
    pub penalties_saved: u16,
}

#[derive(Component)]
pub struct ActivityStats {
    // The total number of mintues spent on the pitch
    pub minutes_played: u16,

    // Total distance covered in meters during the match
    pub distance_covered: f32,

    // High-intensity sprints performed by the player
    pub high_intensity_sprints: u16,

    // Dynamic 1.0-10.0 match performance rating generated at runtime
    pub performance_rating: f32,
}
