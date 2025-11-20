extends RigidBody3D


# Air density (kg/m^3)
const RHO = 1.225 
# Cross-sectional area of the ball (A = pi * r^2)
# r = 0.11 -> A = 0.038
const AREA = 0.038 
# Drag coefficient (Standard sports ball)
const DRAG_COEFF = 0.2 
# Magnus coefficient (Tunable for how much you want it to curve)
const MAGNUS_STRENGTH = 0.25

func _physics_process(delta):
	# 1. APPLY AERODYNAMIC DRAG (Air Resistance)
	# Formula: Fd = -0.5 * rho * v^2 * Cd * A * direction
	var velocity = linear_velocity
	var speed = velocity.length()
	
	if speed > 0:
		var drag_magnitude = 0.5 * RHO * (speed * speed) * DRAG_COEFF * AREA
		var drag_force = -velocity.normalized() * drag_magnitude
		apply_central_force(drag_force)

	# 2. APPLY MAGNUS EFFECT (Curving)
	# Formula: F = S * (AngularVelocity x LinearVelocity)
	var spin = angular_velocity
	if spin.length() > 0 and speed > 0:
		# The cross product gives a vector perpendicular to both spin and velocity
		var magnus_force = spin.cross(velocity) * MAGNUS_STRENGTH
		apply_central_force(magnus_force)
