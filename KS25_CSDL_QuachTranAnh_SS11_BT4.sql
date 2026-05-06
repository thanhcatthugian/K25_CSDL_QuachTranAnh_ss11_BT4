drop database if exists ss11b4;
create database ss11b4;
use ss11b4;

create table victims(
id int primary key auto_increment,
full_name varchar(50) not null,
phone varchar(15) not null  unique,
total_debt decimal(10,2) not null
);

INSERT INTO victims (full_name, phone, total_debt) VALUES
('Nguyen Van An', '0901112222', 500.00),
('Tran Thi Bich', '0912223333', 1250.50),
('Le Hoang Cuong', '0923334444', 175.00),
('Pham Minh Duc', '0934445555', 2100.00),
('Hoang Lan Anh', '0945556666', 750.25),
('Vu Hoang Long', '0956667777', 3000.00),
('Dang Van Hung', '0967778888', 150.00),
('Bui Thi Hanh', '0978889999', 225.00),
('Do Minh Tuan', '0989990000', 4200.75),
('Ngo Thanh Tung', '0990001111', 890.00);

delimiter //
create procedure GetPatientDebt (
	in p_id	int,
    in p_phone varchar(15),
    out p_ann varchar(100)
)
begin
	declare d_id int;
	declare d_phone varchar(15);
    
    select id into d_id from victims
    where id = p_id;
    
    select phone into d_phone from victims
    where p_phone = phone;
    
    if 
    p_id is null and p_phone is null then
    set p_ann = 'Lỗi: Chưa nhập dữ liệu';
    
    elseif p_id != d_id and p_phone != d_phone then
    set p_ann = 'Lỗi: Không tìm thấy';
    
    elseif p_id = d_id or p_phone = d_phone then
    select * from victims
    where id = p_id or phone = d_phone;
    set p_ann = 'Đã tìm thấy';
    
    elseif p_id = d_id and p_phone = d_phone then
    select * from victims
    where id = p_id and phone = d_phone;
    set p_ann = 'Đã tìm thấy';
    end if;
end	
// delimiter ;
set @ann = '';
call GetPatientDebt(null,null,@ann);
select @ann;
call GetPatientDebt(1,null,@ann);
select @ann;
call GetPatientDebt(1,'0901112222',@ann);
select @ann;
call GetPatientDebt(null,'0990001111',@ann);
select @ann;

/*
Sử dụng 2 in, 1 out để in thông báo
Để tìm id hoặc phone có thể so sánh dữ liệu được đưa vào với dữu liệu bảng gốc thông qua biến ảo
rồi sử dụng if-else để phân các trường hợp
-> Code ngắn gọn hơn, ít bị lặp hơn (Chọn cách này)
So sánh trực tiếp với bảng gốc
-> Dễ hiểu hơn nhưng bị lặp nhiều lần select
*/