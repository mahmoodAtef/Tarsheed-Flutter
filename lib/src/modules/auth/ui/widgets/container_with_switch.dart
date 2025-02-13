import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatefulWidget {
  const CustomContainer({
    super.key,
    this.height,
    required this.text,
    this.size,
    this.onTap,
    this.status,
    this.icon,
    this.onpressed,
  });

  final double? height;
  final String text;
  final double? size;
  final VoidCallback? onTap;
  final bool? status;
  final IconData? icon;
  final VoidCallback? onpressed;

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool? status;

  @override
  void initState() {
    super.initState();
    status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          Container(
            width: 340,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: widget.size ?? 20,
                    ),
                  ),
                ),
                if (status != null)
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Switch(
                      inactiveThumbColor: Color(0xFF2666DE),
                      activeColor: Color(0xFFFFFFFF),
                      inactiveTrackColor: Color(0xFFD4E2FD),
                      activeTrackColor: Color(0xFF669BF7),
                      value: status!,
                      onChanged: (val) {
                        setState(() {
                          status = val;
                        });
                      },
                    ),
                  ),
                if (widget.icon != null)
                  IconButton(
                    onPressed: widget.onpressed,
                    icon: Icon(widget.icon, size: 16, color: Colors.black),
                  ),
              ],
            ),
          ),
          Divider(thickness: 1),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
