extends Node2D

@onready var ball: Node2D = $ball
@onready var player: CharacterBody2D = $player
@onready var ai: CharacterBody2D = $ai

@onready var play_btn: Button = $PanelContainer/play_btn
@onready var player_score: Label = $PanelContainer/player_score
@onready var ai_score: Label = $PanelContainer/ai_score


const BALL_SPEED = 150 # px per second
const RACKET_SPEED = 96
const TOP_MARGIN = 24
const COURT_BORDER = 8
const RACKET_HEIGHT = 32
const RACKET_WIDTH = 8
const BALL_HEIGHT = 8
const BALL_WIDTH = 8

const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 240

const AI_X = SCREEN_WIDTH - 32
const PLAYER_X = 32

var player_score_cnt = 0
var ai_score_cnt = 0

var is_playing = false
var ball_velocity: Vector2 = Vector2.ZERO
var ball_speed_multiplier = 1.0

func _ready() -> void:
	play_btn.pressed.connect( play )

func play ( ):
	play_btn.hide( )
	
	var sz = get_viewport_rect().size
	
	ball.position   = sz / 2
	player.position = Vector2( PLAYER_X, sz.y / 2 )
	ai.position     = Vector2( AI_X    , sz.y / 2 )
	is_playing      = true
	ball_speed_multiplier = 1.0
	
	ball_velocity = Vector2( randf( ), randf( ) ).normalized() * BALL_SPEED

func on_player_loose ( ) -> void:
	player_score_cnt += 1
	player_score.text = str(player_score_cnt)
	play( )

func on_ai_loose ( ) -> void:
	ai_score_cnt += 1
	ai_score.text = str(ai_score_cnt)
	play( )

func _physics_process ( delta: float ) -> void:
	if !is_playing:
		return
	
	check_collides_racket( 0, delta )
	check_collides_racket( 1, delta )
	
	ball.position += ball_velocity * delta * ball_speed_multiplier
	
	if ball.position.x < 0:
		on_player_loose()
	elif ball.position.x > SCREEN_WIDTH:
		on_ai_loose()
	elif ball.position.y < 0:
		ball.position.y = min( -ball.position.y, BALL_HEIGHT / 2.0 )
		ball_velocity.y *= -1
	elif ball.position.y > SCREEN_HEIGHT:
		ball.position.y = min( SCREEN_HEIGHT - (ball.position.y - SCREEN_HEIGHT), SCREEN_HEIGHT - ( BALL_HEIGHT / 2.0 ) )
		ball_velocity.y *= -1
	
	var new_ai_pos = ai.position.move_toward( Vector2( ai.position.x, ball.position.y ), RACKET_SPEED * delta )
	ai.position = clamp_racket( new_ai_pos )
	
	var player_y = Input.get_axis( "move_up", "move_down" )
	player.position = clamp_racket( player.position + Vector2( 0, player_y * delta  * RACKET_SPEED ) )


func clamp_racket ( pos: Vector2 ):
	pos.y = clampf( pos.y, RACKET_HEIGHT / 2.0, SCREEN_HEIGHT - RACKET_HEIGHT / 2.0 )
	return pos

func check_collides_racket ( which: int, delta: float ) -> void:
	var r = player if which == 0 else ai
	var h = Vector2( 0, RACKET_HEIGHT + BALL_HEIGHT ) / 2.0
	var to = ball.position + ball_velocity * delta * ball_speed_multiplier
	var i = Geometry2D.segment_intersects_segment( r.position - h, r.position + h, ball.position, to )
	
	if i:
		var percent = (i.y - (r.position.y - h.y)) / RACKET_HEIGHT
		
		if percent < 0.2 or percent > 0.8:
			ball_speed_multiplier = 1.5
		else:
			ball_speed_multiplier = 1.0
		
		if which == 0:
			ball.position = i + Vector2( ( RACKET_WIDTH + BALL_WIDTH ) / 2.0, 0 )
		else:
			ball.position = i - Vector2( ( RACKET_WIDTH + BALL_WIDTH ) / 2.0, 0 )
			
		ball_velocity.x *= -1

#func segment_intersects_rect ( rect: Rect2, from: Vector2, to: Vector2 ) -> Variant:
	#var does_intersect = false
	#var i = Geometry2D.segment_intersects_segment( rect.position, Vector2( rect.position.x + rect.size.x, rect.position.y ), from, to )
	#if i != null:
		#does_intersect = true
		#to = i
#
	#i = Geometry2D.segment_intersects_segment( rect.position, Vector2( rect.position.x, rect.position.y + rect.size.y ), from, to )
	#if i != null:
		#does_intersect = true
		#to = i
		#
	#i = Geometry2D.segment_intersects_segment( 
		  #Vector2( rect.position.x + rect.size.x, rect.position.y               )
		#, Vector2( rect.position.x + rect.size.x, rect.position.y + rect.size.y ), from, to )
	#if i != null:
		#does_intersect = true
		#to = i
		#
	#i = Geometry2D.segment_intersects_segment( 
		  #Vector2( rect.position.x              , rect.position.y + rect.size.y )
		#, Vector2( rect.position.x + rect.size.x, rect.position.y + rect.size.y ), from, to )
	#if i != null:
		#does_intersect = true
		#to = i
#
	#if does_intersect:
		#return to
	#
	#return null
