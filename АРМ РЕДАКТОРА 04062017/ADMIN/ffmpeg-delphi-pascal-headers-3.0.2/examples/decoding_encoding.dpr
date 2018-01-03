(*
 * Copyright (c) 2001 Fabrice Bellard
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *)

(**
 * @file
 * libavcodec API use example.
 *
 * @example decoding_encoding.c
 * Note that libavcodec only handles codecs (mpeg, mpeg4, etc...),
 * not file formats (avi, vob, mp4, mov, mkv, mxf, flv, mpegts, mpegps, etc...). See library 'libavformat' for the
 * format handling
 *)

(*
 * FFVCL - Delphi FFmpeg VCL Components
 * http://www.DelphiFFmpeg.com
 *
 * Original file: doc/examples/decoding_encoding.c
 * Ported by CodeCoolie@CNSW 2014/08/23 -> $Date:: 2016-07-12 #$
 *)

(*
FFmpeg Delphi/Pascal Headers and Examples License Agreement

A modified part of FFVCL - Delphi FFmpeg VCL Components.
Copyright (c) 2008-2016 DelphiFFmpeg.com
All rights reserved.
http://www.DelphiFFmpeg.com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

This source code is provided "as is" by DelphiFFmpeg.com without
warranty of any kind, either expressed or implied, including but not
limited to the implied warranties of merchantability and/or fitness
for a particular purpose.

Please also notice the License agreement of FFmpeg libraries.
*)

program decoding_encoding;

{$APPTYPE CONSOLE}

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFDEF FPC}
  {$IFDEF MSWINDOWS}
    Windows,
  {$ENDIF}
  SysUtils,
{$ELSE}
  {$IF CompilerVersion >= 23.0}
    {$IFDEF MSWINDOWS}
      Winapi.Windows,
    {$ENDIF}
    System.SysUtils,
  {$ELSE}
    {$IFDEF MSWINDOWS}
      Windows,
    {$ENDIF}
    SysUtils,
  {$IFEND}
{$ENDIF}

  FFUtils,

  libavcodec,
  libavcodec_avfft,
  libavdevice,
  libavfilter,
  libavfilter_avcodec,
  libavfilter_buffersink,
  libavfilter_buffersrc,
  libavfilter_formats,
  libavformat,
  libavformat_avio,
  libavformat_url,
  libavutil,
  libavutil_audio_fifo,
  libavutil_avstring,
  libavutil_bprint,
  libavutil_buffer,
  libavutil_channel_layout,
  libavutil_common,
  libavutil_cpu,
  libavutil_dict,
  libavutil_display,
  libavutil_error,
  libavutil_eval,
  libavutil_fifo,
  libavutil_file,
  libavutil_frame,
  libavutil_imgutils,
  libavutil_log,
  libavutil_mathematics,
  libavutil_md5,
  libavutil_mem,
  libavutil_motion_vector,
  libavutil_opt,
  libavutil_parseutils,
  libavutil_pixdesc,
  libavutil_pixfmt,
  libavutil_rational,
  libavutil_samplefmt,
  libavutil_time,
  libavutil_timestamp,
  libswresample,
  libswscale;

const
  INBUF_SIZE          = 4096;
  AUDIO_INBUF_SIZE    = 20480;
  AUDIO_REFILL_THRESH = 4096;

(* check that a given sample format is supported by the encoder *)
function check_sample_fmt(codec: PAVCodec; sample_fmt: TAVSampleFormat): Integer;
var
  p: PAVSampleFormat;
begin
  p := codec.sample_fmts;

  while p^ <> AV_SAMPLE_FMT_NONE do
  begin
    if p^ = sample_fmt then
    begin
      Result := 1;
      Exit;
    end;
    Inc(p);
  end;
  Result := 0;
end;

(* just pick the highest supported samplerate *)
function select_sample_rate(codec: PAVCodec): Integer;
var
  p: PInteger;
  best_samplerate: Integer;
begin
  best_samplerate := 0;

  if not Assigned(codec.supported_samplerates) then
  begin
    Result := 44100;
    Exit;
  end;

  p := codec.supported_samplerates;
  while p^ <> 0 do
  begin
    if best_samplerate < p^ then
      best_samplerate := p^;
    Inc(p);
  end;
  Result := best_samplerate;
end;

(* select layout with the highest channel count *)
function select_channel_layout(codec: PAVCodec): Integer;
var
  p: PInt64;
  best_ch_layout: Int64;
  best_nb_channels: Integer;
  nb_channels: Integer;
begin
  best_ch_layout := 0;
  best_nb_channels := 0;

  if not Assigned(codec.channel_layouts) then
  begin
    Result := AV_CH_LAYOUT_STEREO;
    Exit;
  end;

  p := codec.channel_layouts;
  while p^ <> 0 do
  begin
    nb_channels := av_get_channel_layout_nb_channels(p^);

    if nb_channels > best_nb_channels then
    begin
      best_ch_layout   := p^;
      best_nb_channels := nb_channels;
    end;
    Inc(p);
  end;
  Result := best_ch_layout;
end;

(*
 * Audio encoding example
 *)
procedure audio_encode_example(const filename: string);
var
  codec: PAVCodec;
  c: PAVCodecContext;
  frame: PAVFrame;
  pkt: TAVPacket;
  i, j, k, ret, got_output: Integer;
  buffer_size: Integer;
  f: THandle;
  samples: PSmallInt;
  t, tincr: Single;
begin
  Writeln(Format('Encode audio file %s', [filename]));

  (* find the MP2 encoder *)
  codec := avcodec_find_encoder(AV_CODEC_ID_MP2);
  if not Assigned(codec) then
  begin
    Writeln(ErrOutput, 'Codec not found');
    ExitCode := 1;
    Exit;
  end;

  c := avcodec_alloc_context3(codec);
  if not Assigned(c) then
  begin
    Writeln(ErrOutput, 'Could not allocate audio codec context');
    ExitCode := 1;
    Exit;
  end;

  (* put sample parameters *)
  c.bit_rate := 64000;

  (* check that the encoder supports s16 pcm input *)
  c.sample_fmt := AV_SAMPLE_FMT_S16;
  if check_sample_fmt(codec, c.sample_fmt) = 0 then
  begin
    Writeln(ErrOutput, Format('Encoder does not support sample format %s',
              [string(av_get_sample_fmt_name(c.sample_fmt))]));
    ExitCode := 1;
    Exit;
  end;

  (* select other audio parameters supported by the encoder *)
  c.sample_rate    := select_sample_rate(codec);
  c.channel_layout := select_channel_layout(codec);
  c.channels       := av_get_channel_layout_nb_channels(c.channel_layout);

  (* open it *)
  if avcodec_open2(c, codec, nil) < 0 then
  begin
    Writeln(ErrOutput, 'Could not open codec');
    ExitCode := 1;
    Exit;
  end;

  f := FileCreate(filename);
  if f = INVALID_HANDLE_VALUE then
  begin
    Writeln(ErrOutput, Format('Could not open %s', [filename]));
    ExitCode := 1;
    Exit;
  end;

  (* frame containing input raw audio *)
  frame := av_frame_alloc();
  if not Assigned(frame) then
  begin
    Writeln(ErrOutput, 'Could not allocate audio frame');
    ExitCode := 1;
    Exit;
  end;

  frame.nb_samples     := c.frame_size;
  frame.format         := Ord(c.sample_fmt);
  frame.channel_layout := c.channel_layout;

  (* the codec gives us the frame size, in samples,
   * we calculate the size of the samples buffer in bytes *)
  buffer_size := av_samples_get_buffer_size(nil, c.channels, c.frame_size,
                                           c.sample_fmt, 0);
  if buffer_size < 0 then
  begin
    Writeln(ErrOutput, 'Could not get sample buffer size');
    ExitCode := 1;
    Exit;
  end;
  samples := av_malloc(buffer_size);
  if not Assigned(samples) then
  begin
    Writeln(ErrOutput, Format('Could not allocate %d bytes for samples buffer',
              [buffer_size]));
    ExitCode := 1;
    Exit;
  end;
  (* setup the data pointers in the AVFrame *)
  ret := avcodec_fill_audio_frame(frame, c.channels, c.sample_fmt,
                                 PByte(samples), buffer_size, 0);
  if ret < 0 then
  begin
    Writeln(ErrOutput, 'Could not setup audio frame');
    ExitCode := 1;
    Exit;
  end;

  (* encode a single tone sound *)
  t := 0;
  tincr := 2 * M_PI * 440.0 / c.sample_rate;
  for i := 0 to 200 - 1 do
  begin
    av_init_packet(@pkt);
    pkt.data := nil; // packet data will be allocated by the encoder
    pkt.size := 0;

    for j := 0 to c.frame_size - 1 do
    begin
      PtrIdx(samples, 2*j)^ := Trunc((sin(t) * 10000));

      for k := 1 to c.channels - 1 do
        PtrIdx(samples, 2*j + k)^ := PtrIdx(samples, 2*j)^;
      t := t + tincr;
    end;
    (* encode the samples *)
    ret := avcodec_encode_audio2(c, @pkt, frame, @got_output);
    if ret < 0 then
    begin
      Writeln(ErrOutput, 'Error encoding audio frame');
      ExitCode := 1;
      Exit;
    end;

    if got_output <> 0 then
    begin
      FileWrite(f, pkt.data^, pkt.size);
      av_packet_unref(@pkt);
    end;
  end;

  (* get the delayed frames *)
  repeat
    ret := avcodec_encode_audio2(c, @pkt, nil, @got_output);
    if ret < 0 then
    begin
      Writeln(ErrOutput, 'Error encoding audio frame');
      ExitCode := 1;
      Exit;
    end;

    if got_output <> 0 then
    begin
      FileWrite(f, pkt.data^, pkt.size);
      av_packet_unref(@pkt);
    end;
  until got_output = 0;
  FileClose(f);

  av_freep(@samples);
  av_frame_free(@frame);
  avcodec_close(c);
  av_free(c);
end;

(*
 * Audio decoding.
 *)
procedure audio_decode_example(const outfilename, filename: string);
var
  codec: PAVCodec;
  c: PAVCodecContext;
  len: Integer;
  f, outfile: THandle;
  inbuf: array[0..AUDIO_INBUF_SIZE + AV_INPUT_BUFFER_PADDING_SIZE - 1] of Byte;
  avpkt: TAVPacket;
  decoded_frame: PAVFrame;
  got_frame: Integer;
  data_size: Integer;
  i, ch: Integer;
begin
  decoded_frame := nil;

  av_init_packet(@avpkt);

  Writeln(Format('Decode audio file %s to %s', [filename, outfilename]));

  (* find the mpeg audio decoder *)
  codec := avcodec_find_decoder(AV_CODEC_ID_MP2);
  if not Assigned(codec) then
  begin
    Writeln(ErrOutput, 'Codec not found');
    ExitCode := 1;
    Exit;
  end;

  c := avcodec_alloc_context3(codec);
  if not Assigned(c) then
  begin
    Writeln(ErrOutput, 'Could not allocate audio codec context');
    ExitCode := 1;
    Exit;
  end;

  (* open it *)
  if avcodec_open2(c, codec, nil) < 0 then
  begin
    Writeln(ErrOutput, 'Could not open codec');
    ExitCode := 1;
    Exit;
  end;

  f := FileOpen(filename, fmOpenRead);
  if f = INVALID_HANDLE_VALUE then
  begin
    Writeln(ErrOutput, Format('Could not open %s', [filename]));
    ExitCode := 1;
    Exit;
  end;
  outfile := FileCreate(outfilename);
  if outfile = INVALID_HANDLE_VALUE then
  begin
    Writeln(ErrOutput, Format('Could not open %s', [outfilename]));
    av_free(c);
    ExitCode := 1;
    Exit;
  end;

  (* decode until eof *)
  avpkt.data := @inbuf[0];
  avpkt.size := FileRead(f, inbuf[0], AUDIO_INBUF_SIZE);

  while avpkt.size > 0 do
  begin
    got_frame := 0;

    if not Assigned(decoded_frame) then
    begin
      decoded_frame := av_frame_alloc();
      if not Assigned(decoded_frame) then
      begin
        Writeln(ErrOutput, 'Could not allocate audio frame');
        ExitCode := 1;
        Exit;
      end;
    end;

    len := avcodec_decode_audio4(c, decoded_frame, @got_frame, @avpkt);
    if len < 0 then
    begin
      Writeln(ErrOutput, 'Error while decoding');
      ExitCode := 1;
      Exit;
    end;

    if got_frame <> 0 then
    begin
      (* if a frame has been decoded, output it *)
      data_size := av_get_bytes_per_sample(c.sample_fmt);
      if data_size < 0 then
      begin
        (* This should not occur, checking just for paranoia *)
        Writeln(ErrOutput, 'Failed to calculate data size');
        ExitCode := 1;
        Exit;
      end;
      for i := 0 to decoded_frame.nb_samples - 1 do
        for ch := 0 to c.channels - 1 do
          FileWrite(outfile, PByte(Integer(decoded_frame.data[ch]) + data_size * i)^, data_size);
    end;
    Dec(avpkt.size, len);
    Inc(avpkt.data, len);
    avpkt.dts := AV_NOPTS_VALUE;
    avpkt.pts := AV_NOPTS_VALUE;
    if avpkt.size < AUDIO_REFILL_THRESH then
    begin
      (* Refill the input buffer, to avoid trying to decode
       * incomplete frames. Instead of this, one could also use
       * a parser, or use a proper container format through
       * libavformat. *)
      Move(avpkt.data^, inbuf[0], avpkt.size);
      avpkt.data := @inbuf[0];
      len := FileRead(f, PByte(PAnsiChar(avpkt.data) + avpkt.size)^,
                  AUDIO_INBUF_SIZE - avpkt.size);
      if len > 0 then
        Inc(avpkt.size, len);
    end;
  end;

  FileClose(outfile);
  FileClose(f);

  avcodec_close(c);
  av_free(c);
  av_frame_free(@decoded_frame);
end;

(*
 * Video encoding example
 *)
procedure video_encode_example(const filename: string; codec_id: TAVCodecID);
const
  endcode: array[0..3] of Byte = ( 0, 0, 1, $b7 );
var
  codec: PAVCodec;
  c: PAVCodecContext;
  idx, i, ret, x, y, got_output: Integer;
  f: THandle;
  frame: PAVFrame;
  pkt: TAVPacket;
begin
  Writeln(Format('Encode video file %s', [filename]));

  (* find the mpeg1 video encoder *)
  codec := avcodec_find_encoder(codec_id);
  if not Assigned(codec) then
  begin
    Writeln(ErrOutput, 'Codec not found');
    ExitCode := 1;
    Exit;
  end;

  c := avcodec_alloc_context3(codec);
  if not Assigned(c) then
  begin
    Writeln(ErrOutput, 'Could not allocate video codec context');
    ExitCode := 1;
    Exit;
  end;

  (* put sample parameters *)
  c.bit_rate := 400000;
  (* resolution must be a multiple of two *)
  c.width := 352;
  c.height := 288;
  (* frames per second *)
  c.time_base.num := 1;
  c.time_base.den := 25;
  (* emit one intra frame every ten frames
   * check frame pict_type before passing frame
   * to encoder, if frame->pict_type is AV_PICTURE_TYPE_I
   * then gop_size is ignored and the output of encoder
   * will always be I frame irrespective to gop_size
   *)
  c.gop_size := 10;
  c.max_b_frames := 1;
  c.pix_fmt := AV_PIX_FMT_YUV420P;

  if codec_id = AV_CODEC_ID_H264 then
    av_opt_set(c.priv_data, 'preset', 'slow', 0);

  (* open it *)
  if avcodec_open2(c, codec, nil) < 0 then
  begin
    Writeln(ErrOutput, 'Could not open codec');
    ExitCode := 1;
    Exit;
  end;

  f := FileCreate(filename);
  if f = INVALID_HANDLE_VALUE then
  begin
    Writeln(ErrOutput, Format('Could not open %s', [filename]));
    ExitCode := 1;
    Exit;
  end;

  frame := av_frame_alloc();
  if not Assigned(frame) then
  begin
    Writeln(ErrOutput, 'Could not allocate video frame');
    ExitCode := 1;
    Exit;
  end;
  frame.format := Ord(c.pix_fmt);
  frame.width  := c.width;
  frame.height := c.height;

  (* the image can be allocated by any means and av_image_alloc() is
   * just the most convenient way if av_malloc() is to be used *)
  ret := av_image_alloc(@frame.data[0], @frame.linesize[0], c.width, c.height,
                       c.pix_fmt, 32);
  if ret < 0 then
  begin
    Writeln(ErrOutput, 'Could not allocate raw picture buffer');
    ExitCode := 1;
    Exit;
  end;

  (* encode 1 second of video *)
  idx := 1;
  for i := 0 to 25 - 1 do
  begin
    av_init_packet(@pkt);
    pkt.data := nil;    // packet data will be allocated by the encoder
    pkt.size := 0;

    //fflush(stdout);
    (* prepare a dummy image *)
    (* Y *)
    for y := 0 to c.height - 1 do
      for x := 0 to c.width - 1 do
        PByte(@PAnsiChar(frame.data[0])[y * frame.linesize[0] + x])^ := x + y + i * 3;

    (* Cb and Cr *)
    for y := 0 to c.height div 2 - 1 do
      for x := 0 to c.width div 2 - 1 do
      begin
        PByte(@PAnsiChar(frame.data[1])[y * frame.linesize[1] + x])^ := 128 + y + i * 2;
        PByte(@PAnsiChar(frame.data[2])[y * frame.linesize[2] + x])^ := 64 + x + i * 5;
      end;

    frame.pts := i;

    (* encode the image *)
    ret := avcodec_encode_video2(c, @pkt, frame, @got_output);
    if ret < 0 then
    begin
      Writeln(ErrOutput, 'Error encoding frame');
      ExitCode := 1;
      Exit;
    end;

    if got_output <> 0 then
    begin
      Writeln(Format('Write frame %d (size=%d)', [idx, pkt.size]));
      FileWrite(f, pkt.data^, pkt.size);
      av_packet_unref(@pkt);
      Inc(idx);
    end;
  end;

  (* get the delayed frames *)
  repeat
    //fflush(stdout);

    ret := avcodec_encode_video2(c, @pkt, nil, @got_output);
    if ret < 0 then
    begin
      Writeln(ErrOutput, 'Error encoding frame');
      ExitCode := 1;
      Exit;
    end;

    if got_output <> 0 then
    begin
      Writeln(Format('Write frame %d (size=%d)', [idx, pkt.size]));
      FileWrite(f, pkt.data^, pkt.size);
      av_packet_unref(@pkt);
      Inc(idx);
    end;
  until got_output = 0;

  (* add sequence end code to have a real mpeg file *)
  FileWrite(f, endcode[0], SizeOf(endcode));
  FileClose(f);

  avcodec_close(c);
  av_free(c);
  av_freep(@frame.data[0]);
  av_frame_free(@frame);
  Writeln('');
end;

(*
 * Video decoding example
 *)

procedure pgm_save(buf: PByte; wrap, xsize, ysize: Integer;
  filename: string);
var
  f: THandle;
  i: Integer;
  s: AnsiString;
begin
  f := FileCreate(filename);
  if f = INVALID_HANDLE_VALUE then
  begin
    Writeln(ErrOutput, Format('Could not open %s', [filename]));
    ExitCode := 1;
    Exit;
  end;
  s := AnsiString(Format('P5'#10'%d %d'#10'%d'#10, [xsize, ysize, 255]));
  FileWrite(f, s[1], Length(s));
  for i := 0 to ysize - 1 do
    FileWrite(f, PByte(PAnsiChar(buf) + i * wrap)^, xsize);
  FileClose(f);
end;

function decode_write_frame(const outfilename: string; avctx: PAVCodecContext;
  frame: PAVFrame; frame_count: PInteger; pkt: PAVPacket; last: Integer): Integer;
var
  len, got_frame: Integer;
begin
  len := avcodec_decode_video2(avctx, frame, @got_frame, pkt);
  if len < 0 then
  begin
    Writeln(ErrOutput, Format('Error while decoding frame %d', [frame_count^]));
    Result := len;
    Exit;
  end;
  if got_frame <> 0 then
  begin
    if last <> 0 then
      Writeln(Format('Saving %sframe %3d', ['last ', frame_count^]))
    else
      Writeln(Format('Saving %sframe %3d', ['', frame_count^]));
    //fflush(stdout);

    (* the picture is allocated by the decoder, no need to free it *)
    pgm_save(frame.data[0], frame.linesize[0],
             frame.width, frame.height, Format(outfilename, [frame_count^]));
    Inc(frame_count^);
  end;
  if Assigned(pkt.data) then
  begin
    Dec(pkt.size, len);
    Inc(pkt.data, len);
  end;
  Result := 0;
end;

procedure video_decode_example(const outfilename, filename: string);
var
  codec: PAVCodec;
  c: PAVCodecContext;
  frame_count: Integer;
  f: THandle;
  frame: PAVFrame;
  inbuf: array[0..INBUF_SIZE + AV_INPUT_BUFFER_PADDING_SIZE - 1] of Byte;
  avpkt: TAVPacket;
begin
  av_init_packet(@avpkt);

  (* set end of buffer to 0 (this ensures that no overreading happens for damaged mpeg streams) *)
  FillChar(inbuf[INBUF_SIZE], AV_INPUT_BUFFER_PADDING_SIZE, 0);

  Writeln(Format('Decode video file %s to %s', [filename, outfilename]));

  (* find the mpeg1 video decoder *)
  codec := avcodec_find_decoder(AV_CODEC_ID_MPEG1VIDEO);
  if not Assigned(codec) then
  begin
    Writeln(ErrOutput, 'Codec not found');
    ExitCode := 1;
    Exit;
  end;

  c := avcodec_alloc_context3(codec);
  if not Assigned(c) then
  begin
    Writeln(ErrOutput, 'Could not allocate video codec context');
    ExitCode := 1;
    Exit;
  end;

  if (codec.capabilities and AV_CODEC_CAP_TRUNCATED) <> 0 then
    c.flags := c.flags or AV_CODEC_FLAG_TRUNCATED; // we do not send complete frames

  (* For some codecs, such as msmpeg4 and mpeg4, width and height
     MUST be initialized there because this information is not
     available in the bitstream. *)

  (* open it *)
  if avcodec_open2(c, codec, nil) < 0 then
  begin
    Writeln(ErrOutput, 'Could not open codec');
    ExitCode := 1;
    Exit;
  end;

  f := FileOpen(filename, fmOpenRead);
  if f = INVALID_HANDLE_VALUE then
  begin
    Writeln(ErrOutput, Format('Could not open %s', [filename]));
    ExitCode := 1;
    Exit;
  end;

  frame := av_frame_alloc();
  if not Assigned(frame) then
  begin
    Writeln(ErrOutput, 'Could not allocate video frame');
    ExitCode := 1;
    Exit;
  end;

  frame_count := 0;
  while True do
  begin
    avpkt.size := FileRead(f, inbuf[0], INBUF_SIZE);
    if avpkt.size = 0 then
      Break;

    (* NOTE1: some codecs are stream based (mpegvideo, mpegaudio)
       and this is the only method to use them because you cannot
       know the compressed data size before analysing it.

       BUT some other codecs (msmpeg4, mpeg4) are inherently frame
       based, so you must call them with all the data for one
       frame exactly. You must also initialize 'width' and
       'height' before initializing them. *)

    (* NOTE2: some codecs allow the raw parameters (frame size,
       sample rate) to be changed at any frame. We handle this, so
       you should also take care of it *)

    (* here, we use a stream based decoder (mpeg1video), so we
       feed decoder and see if it could decode a frame *)
    avpkt.data := @inbuf[0];
    while avpkt.size > 0 do
      if decode_write_frame(outfilename, c, frame, @frame_count, @avpkt, 0) < 0 then
      begin
        ExitCode := 1;
        Exit;
      end;
  end;

  (* some codecs, such as MPEG, transmit the I and P frame with a
     latency of one frame. You must do the following to have a
     chance to get the last frame of the video *)
  avpkt.data := nil;
  avpkt.size := 0;
  decode_write_frame(outfilename, c, frame, @frame_count, @avpkt, 1);

  FileClose(f);

  avcodec_close(c);
  av_free(c);
  av_frame_free(@frame);
  Writeln('');
end;

function main(): Integer;
var
  output_type: string;
begin
  (* register all the codecs *)
  avcodec_register_all();

  if ParamCount < 1 then
  begin
    Writeln(Format(
        'usage: %s output_type' + sLineBreak +
        'API example program to decode/encode a media stream with libavcodec.' + sLineBreak +
        'This program generates a synthetic stream and encodes it to a file' + sLineBreak +
        'named test.h264, test.mp2 or test.mpg depending on output_type.' + sLineBreak +
        'The encoded stream is then decoded and written to a raw data output.' + sLineBreak +
        'output_type must be chosen between ''h264'', ''mp2'', ''mpg''.',
        [ExtractFileName(ParamStr(0))]));
    Result := 1;
    Exit;
  end;
  output_type := ParamStr(1);

  if output_type = 'h264' then
    video_encode_example('test.h264', AV_CODEC_ID_H264)
  else if output_type = 'mp2' then
  begin
    audio_encode_example('test.mp2');
    audio_decode_example('test.pcm', 'test.mp2');
  end
  else if output_type = 'mpg' then
  begin
    video_encode_example('test.mpg', AV_CODEC_ID_MPEG1VIDEO);
    video_decode_example('test%.2d.pgm', 'test.mpg');
  end
  else
  begin
    Writeln(ErrOutput, Format('Invalid output type ''%s'', choose between ''h264'', ''mp2'', or ''mpg''',
              [string(output_type)]));
    Result := 1;
    Exit;
  end;

  Result := 0;
end;

begin
  try
    ExitCode := main();
  except
    on E: Exception do
      Writeln(ErrOutput, E.ClassName, ': ', E.Message);
  end;
end.
