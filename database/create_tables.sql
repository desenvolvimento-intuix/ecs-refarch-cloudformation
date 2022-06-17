create table if not exists camera (
	id serial primary key,
	street varchar(255),
	neighborhood varchar(255),
	city varchar(255),
	state varchar(255),
	endpoint_input varchar(2000) unique not null,
	endpoint_output varchar(2000) unique not null
);

create table if not exists camera_action (
	camera_id int unique not null,
    detect_face boolean not null default false,
    foreign key(camera_id) references camera(id)
);

create table if not exists image (
	id serial primary key,
	camera_id int not null,
	path varchar (255) not null,
	processing timestamp with time zone default current_timestamp,
    foreign key(camera_id) references camera(id)
);

create table if not exists detected_object (
	id serial primary key,
	image_id int not null,
	processing timestamp with time zone default current_timestamp,
    foreign key(image_id) references image(id)
);

create table if not exists detected_object_class (
	id serial primary key,
	detected_object_id int not null,
	class varchar(255) not null,
	tracking_id int not null,
	inference float not null,
	x int not null,
	y int not null,
	h int not null,
	w int not null,
    foreign key(detected_object_id) references detected_object(id)
);

create table if not exists recognized_plate (
	id serial primary key,
	detected_object_id int not null,
	plate varchar(15) not null,
	inference float not null,
    foreign key(detected_object_id) references detected_object(id)
);

create table if not exists detected_face (
	id serial primary key,
	detected_object_id int not null,
	recognized varchar(255) not null,
	inference float not null,
	refined_image varchar(2000) not null,
	x int not null,
	y int not null,
	h int not null,
	w int not null,
    foreign key(detected_object_id) references detected_object(id)
);

create table if not exists model_state (
    id serial primary key,
    name varchar(255) not null,
    state varchar(255) not null
);
